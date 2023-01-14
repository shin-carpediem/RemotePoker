import Foundation

final class EnterRoomPresenter: EnterRoomPresentation, EnterRoomInteractorOutput,
    DependencyInjectable
{
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

    var currentRoom: Room = .init(id: 0, userList: [], cardPackage: .defaultCardPackage)

    func didTapEnterCurrentRoomButton() {
        Task {
            await disableButton(true)
            await showLoader(true)
            dependency.useCase.setupRoomRepository(roomId: currentRoomId)
            setupExistingCurrentUser()
            enterRoomAction = .enterCurrentRoom
            await setupRoom(userName: currentUser.name, roomId: currentRoomId)
            await pushCardListView()
        }
    }

    func didCancelEnterCurrentRoomButton() {
        enterRoomAction = .enterOtherRoom(isNew: false)
    }

    func didTapEnterRoomButton(inputUserName: String, inputRoomId: String) {
        Task {
            await disableButton(true)
            if let viewModel = dependency.viewModel, await !viewModel.isInputFormValid {
                await disableButton(false)
            } else {
                await showLoader(true)
                let roomId = Int(inputRoomId)!
                dependency.useCase.setupRoomRepository(roomId: roomId)
                setupNewCurrentUser(userName: inputUserName, roomId: roomId)
                await dependency.useCase.checkRoomExist(roomId: roomId)
                enterRoomAction = .enterOtherRoom(isNew: !roomExist)
                await setupRoom(userName: currentUser.name, roomId: currentRoomId)
                await pushCardListView()
            }
        }
    }

    // MARK: - EnterRoomInteractorOutput

    func outputUser(_ user: User) {
        Task {
            currentUser = user
            await disableButton(false)
            await showLoader(false)
        }
    }

    func outputRoom(_ room: Room) {
        Task {
            currentRoom = room
            await disableButton(false)
            await showLoader(false)
        }
    }

    func outputRoomExist(_ exist: Bool) {
        Task {
            roomExist = exist
            await disableButton(false)
            await showLoader(false)
        }
    }

    @MainActor func outputSuccess(message: String) {
        dependency.viewModel?.bannerMessgage = .init(type: .onSuccess, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    @MainActor func outputError(_ error: Error, message: String) {
        dependency.viewModel?.bannerMessgage = .init(type: .onFailure, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    // MARK: - Private

    private var dependency: Dependency!

    /// カレントルームID
    private var currentRoomId: Int {
        get { LocalStorage.shared.currentRoomId }
        set { LocalStorage.shared.currentRoomId = newValue }
    }

    /// どのルームに入るか
    private var enterRoomAction: EnterRoomAction = .enterOtherRoom(isNew: true)

    /// ルームが存在するか
    private var roomExist = false

    /// ユーザーに、存在するカレントルームがあるか確認する
    private func checkUserInCurrentRoom() async {
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String, appVersion == "1.0.0" || appVersion == "1.1.0"
        {
            // アプリバージョンが1.1.0以下のユーザーデータはFirestoreから削除されているため、カレントルームは存在しない
            enterRoomAction = .enterOtherRoom(isNew: true)
            roomExist = false
            return
        }

        if currentRoomId == 0 {
            enterRoomAction = .enterOtherRoom(isNew: true)
            roomExist = false
        } else {
            await dependency.useCase.checkRoomExist(roomId: currentRoomId)
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
        guard let userId = userId else { fatalError() }
        dependency.useCase.requestUser(userId: userId)
    }

    /// 新規カレントユーザーをセットアップする
    private func setupNewCurrentUser(userName: String, roomId: Int) {
        currentRoomId = roomId
        currentUser = .init(
            id: currentUser.id,
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

        case .enterOtherRoom(isNew: false):
            dependency.useCase.setupRoomRepository(roomId: roomId)
            await dependency.useCase.adduserToRoom(user: currentUser)

        case .enterOtherRoom(isNew: true):
            currentRoom = .init(
                id: roomId,
                userList: [currentUser],
                cardPackage: .defaultCardPackage)
            await dependency.useCase.createRoom(room: currentRoom)
            dependency.useCase.setupRoomRepository(roomId: currentRoom.id)
        }

        await dependency.useCase.requestRoom(roomId: roomId)
    }

    /// カレントルームに入るか促すアラートを表示する
    @MainActor private func showEnterCurrentRoomAlert() {
        dependency.viewModel?.isShownEnterCurrentRoomAlert = true
        disableButton(false)
        showLoader(false)
    }

    /// ボタンを無効にする
    @MainActor private func disableButton(_ disabled: Bool) {
        dependency.viewModel?.isButtonEnabled = !disabled
    }

    /// ローダーを表示する
    @MainActor private func showLoader(_ show: Bool) {
        dependency.viewModel?.isShownLoader = show
    }

    // MARK: - Router

    /// カード一覧画面に遷移する
    @MainActor private func pushCardListView() {
        dependency.viewModel?.willPushCardListView = true
        disableButton(false)
        showLoader(false)
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
            if roomExist {
                // 存在する場合
                // ルームリポジトリにルームIDをセットする
                dependency.useCase.setupRoomRepository(roomId: currentRoomId)
                // カレントルームに入室するか促すアラートを表示する
                await showEnterCurrentRoomAlert()
            }
        }
    }

    func whenFailedToLogin(error: RoomAuthError) {
        Task {
            let message = "Failed to login. Please re-install app."
            await outputError(error, message: message)
        }
    }
}
