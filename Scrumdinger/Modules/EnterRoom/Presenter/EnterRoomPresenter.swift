import Foundation

final class EnterRoomPresenter: EnterRoomPresentation, EnterRoomInteractorOutput, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var useCase: EnterRoomUseCase
        weak var viewModel: EnterRoomViewModel?
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Presentation
    
    func viewDidLoad() {}
    
    func viewDidResume() {
        login()
    }
    
    func viewDidSuspend() {}
    
    // MARK: - EnterRoomPresentation
    
    var currentUser: User = .init(id: "", name: "", currentRoomId: 0, selectedCardId: "")
    
    var currentRoom: Room?
    
    func isInputFormValid() -> Bool {
        if let viewModel = dependency.viewModel, !viewModel.inputName.isEmpty, let inputInt = Int(viewModel.inputRoomId) {
            return String(inputInt).count == 4
        } else {
            return false
        }
    }
    
    func showInputInvalidAlert() {
        // TODO: Actorで置き換える
        // https://qiita.com/uhooi/items/1d2c94df69c75fcfbdbf
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownInputFormInvalidAlert = true
        }
    }
    
    func didTapEnterCurrentRoomButton() {
        Task {
            disableButton(true)
            showLoader(true)
            dependency.useCase.setupRoomRepository(roomId: currentRoomId)
            setupExistingCurrentUser()
            enterRoomAction = .enterCurrentRoom
            await setupRoom(userName: currentUser.name, roomId: currentRoomId)
            pushCardListView()
        }
    }
    
    func didCancelEnterCurrentRoomButton() {
        enterRoomAction = .enterOtherExistingRoom
    }
    
    func didTapEnterRoomButton(userName: String, roomId: Int) {
        Task {
            disableButton(true)
            showLoader(true)
            dependency.useCase.setupRoomRepository(roomId: roomId)
            setupNewCurrentUser(userName: userName, roomId: roomId)
            enterRoomAction = isUserInCurrentRoom ? .enterOtherExistingRoom : .enterNewRoom
            await setupRoom(userName: currentUser.name, roomId: currentRoomId)
            pushCardListView()
        }
    }
    
    // MARK: - EnterRoomInteractorOutput
    
    func outputUser(_ user: User) {
        currentUser = user
        disableButton(false)
        showLoader(false)
    }
    
    func outputRoom(_ room: Room) {
        currentRoom = room
        disableButton(false)
        showLoader(false)
    }
    
    func outputIsUserInCurrentRoom(_ isIn: Bool) {
        isUserInCurrentRoom = isIn
        disableButton(false)
        showLoader(false)
    }
    
    func outputEnterCurrentRoomAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownEnterCurrentRoomAlert = true
            self?.disableButton(false)
            self?.showLoader(false)
        }
    }
    
    func outputSuccess(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.bannerMessgage = .init(type: .onSuccess, text: message)
            self?.dependency.viewModel?.isShownBanner = true
        }
    }
    
    func outputError(_ error: Error, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.bannerMessgage = .init(type: .onFailure, text: message)
            self?.dependency.viewModel?.isShownBanner = true
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// カレントルームID
    private var currentRoomId: Int {
        get { LocalStorage.shared.currentRoomId }
        set { LocalStorage.shared.currentRoomId = newValue }
    }
    
    /// どのルームに入るか
    private var enterRoomAction: EnterRoomAction = .enterNewRoom
    
    /// ユーザーが、存在する既存のルーム(=カレントルーム)に存在するか
    private var isUserInCurrentRoom = false
    
    /// ユーザーに、存在するカレントルームがあるか確認する
    private func checkUserInCurrentRoom() async {
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, appVersion == "1.0.0" || appVersion == "1.1.0" {
            // アプリバージョンが1.1.0以下のユーザーデータはFirestoreから削除されているため、カレントルームは存在しない
            isUserInCurrentRoom = false
            return
        }
        
        if currentRoomId == 0 {
            isUserInCurrentRoom = false
        } else {
            await dependency.useCase.checkUserInCurrentRoom(roomId: currentRoomId)
        }
    }
    
    /// 匿名ログインする
    private func login() {
        RoomAuthDataStore.shared.delegate = self
        RoomAuthDataStore.shared.login()
    }
    
    /// 既存カレントユーザーをセットアップする
    private func setupExistingCurrentUser() {
        let userId = RoomAuthDataStore.shared.fetchUserId()
        guard let userId else { fatalError() }
        dependency.useCase.requestUser(userId: userId)
    }
    
    /// 新規カレントユーザーをセットアップする
    private func setupNewCurrentUser(userName: String, roomId: Int) {
        currentRoomId = roomId
        currentUser = .init(id: currentUser.id,
                            name: userName,
                            currentRoomId: roomId,
                            selectedCardId: "")
    }
    
    /// ルームをセットアップする
    private func setupRoom(userName: String, roomId: Int) async {
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
            dependency.useCase.setupRoomRepository(roomId: currentRoom!.id)
        }
        
        await dependency.useCase.requestRoom(roomId: roomId)
    }
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isButtonEnabled = !disabled
        }
    }
    
    /// ローダーを表示する
    private func showLoader(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownLoader = show
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
        Task {
            // 匿名ログイン後取得したユーザーIDをカレントユーザーIDとする
            currentUser.id = userId
            // ローカルに保存されているカレントルームIDを基にカレントルームがFirestore上に存在するか確認する
            await checkUserInCurrentRoom()
            if isUserInCurrentRoom {
                // 存在する場合
                // ルームリポジトリにルームIDをセットする
                dependency.useCase.setupRoomRepository(roomId: currentRoomId)
                // カレントルームに入室するか促すアラートを表示する
                outputEnterCurrentRoomAlert()
            }
        }
    }
    
    func whenFailedToLogin(error: RoomAuthError) {
        outputError(error, message: "Failed to login. Please re-install app.")
    }
}
