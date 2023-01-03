import Foundation

final class EnterRoomPresenter: EnterRoomPresentation, EnterRoomInteractorOutput, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var useCase: EnterRoomUseCase
        weak var viewModel: EnterRoomViewModel?
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
        RoomAuthDataStore.shared.delegate = self
    }
    
    // MARK: - EnterRoomPresentation
    
    var currentUser: User = .init(id: "", name: "", currentRoomId: 0, selectedCardId: "")
    
    var currentRoom: Room?
    
    var enterRoomAction: EnterRoomAction = .enterNewRoom
    
    func isInputFormValid() -> Bool {
        guard let viewModel = dependency.viewModel else { return false }
        guard !viewModel.inputName.isEmpty else { return false }
        guard let inputInt = Int(viewModel.inputRoomId) else { return false }
        return String(inputInt).count == 4
    }
    
    func showInputInvalidAlert() {
        // TODO: Actorで置き換える
        // https://qiita.com/uhooi/items/1d2c94df69c75fcfbdbf
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownInputFormInvalidAlert = true
        }
    }
    
    func didTapEnterCurrentRoomButton() {
        disableButton(true)
        enterRoomAction = .enterCurrentRoom
        setupCurrentUser(userName: nil, roomId: nil)
        setupRoom(userName: currentUser.name, roomId: currentRoomId)
        pushCardListView()
    }
    
    func didCancelEnterCurrentRoomButton() {
        enterRoomAction = .enterOtherExistingRoom
    }
    
    func didTapEnterRoomButton(userName: String, roomId: Int) {
        disableButton(true)
        RoomAuthDataStore.shared.login()
        enterRoomAction = isUserInCurrentRoom ? .enterOtherExistingRoom : .enterNewRoom
        setupCurrentUser(userName: userName, roomId: roomId)
        setupRoom(userName: userName, roomId: roomId)
        pushCardListView()
    }
    
    // MARK: - Presentation
    
    func viewDidLoad() {}
    
    func viewDidResume() {
        RoomAuthDataStore.shared.login()
    }
    
    func viewDidSuspend() {}
    
    func viewDidStop() {}
    
    // MARK: - EnterRoomPresentationOutput
    
    func outputIsUserInCurrentRoom(_ isIn: Bool) {
        isUserInCurrentRoom = isIn
    }
    
    func outputEnterCurrentRoomAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownEnterCurrentRoomAlert = true
        }
    }
    
    func outputUser(_ user: User) {
        currentUser = user
    }
    
    func outputRoom(_ room: Room) {
        currentRoom = room
    }
    
    func outputSuccess() {
        
    }
    
    func outputError(_ error: Error) {
        
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// カレントルームID
    private var currentRoomId = LocalStorage.shared.currentRoomId
    
    /// ユーザーが、存在する既存のルーム(=カレントルーム)に存在するか
    private var isUserInCurrentRoom = false
    
    /// ユーザーに、存在するカレントルームがあるか確認する
    private func checkUserInCurrentRoom() {
        Task {
            if currentRoomId == 0 {
                isUserInCurrentRoom = false
            } else {
                await dependency.useCase.checkUserInCurrentRoom(roomId: currentRoomId)
            }
        }
    }
    
    /// カレントユーザーをセットアップする
    private func setupCurrentUser(userName: String?, roomId: Int?) {
        if isUserInCurrentRoom {
            // 既存ユーザー
            let userId = RoomAuthDataStore.shared.fetchUserId()
            guard let userId else { fatalError() }
            dependency.useCase.requestUser(userId: userId)
        } else {
            // 新規ユーザー
            currentRoomId = roomId!
            currentUser = .init(id: currentUser.id,
                                name: userName!,
                                currentRoomId: roomId!,
                                selectedCardId: "")
        }
    }
    
    /// ルームをセットアップする
    private func setupRoom(userName: String, roomId: Int) {
        Task {
            currentRoomId = roomId

            switch enterRoomAction {
            case .enterCurrentRoom:
                dependency.useCase.setupRoomRepository(roomId: roomId)
            
            case .enterOtherExistingRoom:
                dependency.useCase.setupRoomRepository(roomId: roomId)
                await dependency.useCase.adduserToRoom(user: currentUser)
            
            case .enterNewRoom:
                currentRoom = .init(id: roomId,
                                    userList: [currentUser],
                                    cardPackage: .defaultCardPackage)
                await dependency.useCase.createRoom(room: currentRoom!)
            }
            
            await dependency.useCase.requestRoom(roomId: roomId)
        }
    }
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isButtonEnabled = !disabled
            self?.dependency.viewModel?.activityIndicator.isAnimating = disabled
        }
    }
    
    // MARK: - Router
    
    /// カード一覧画面に遷移する
    private func pushCardListView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.willPushCardListView = true
            self?.disableButton(false)
        }
    }
}

// MARK: RoomAuthDelegate

extension EnterRoomPresenter: RoomAuthDelegate {
    func whenSuccessLogin(userId: String) {
        // 匿名ログイン後取得したユーザーIDをセットする
        currentUser.id = userId
        // LocalStorageに保存されているカレントルームIDを基にカレントルームが存在するか確認する
        checkUserInCurrentRoom()
        if isUserInCurrentRoom {
            // 以後のFirestoreRefにルームIDをセットする
            dependency.useCase.setupRoomRepository(roomId: currentRoomId)
            // カレントルームに入室するか促すアラートを表示する
            outputEnterCurrentRoomAlert()
        }
    }
    
    func whenFailedToLogin(error: RoomAuthError) {
        outputError(error)
    }
}
