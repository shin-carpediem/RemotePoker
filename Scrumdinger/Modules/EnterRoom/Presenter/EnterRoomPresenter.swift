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

    // MARK: - EnterRoomPresentation

    func viewDidLoad() {}

    func viewDidResume() {}

    func viewDidSuspend() {}

    var currentUser = User(
        id: "",
        name: "",
        currentRoomId: 0,
        selectedCardId: "")

    var currentRoom = Room(id: 0, userList: [], cardPackage: .defaultCardPackage)

    func didTapEnterRoomButton(inputUserName: String, inputRoomId: String) {
        Task {
            await disableButton(true)
            if let viewModel: EnterRoomViewModel = dependency.viewModel,
                await viewModel.isInputFormValid
            {
                // フォーム内容が有効
                await showLoader(true)
                let roomId = Int(inputRoomId)!
                await dependency.useCase.login(userName: inputUserName, roomId: roomId)
            } else {
                // フォーム内容が有効ではない
            }
            await disableButton(false)
            await showLoader(false)
        }
    }

    // MARK: - EnterRoomInteractorOutput

    func outputCompletedLogin(userId: String, userName: String, roomId: Int) {
        Task {
            await setupUserAndRoom(userId: userId, userName: userName, roomId: roomId)
            await pushCardListView()
        }
    }

    @MainActor
    func outputSuccess(message: String) {
        dependency.viewModel?.bannerMessgage = NotificationMessage(type: .onSuccess, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    @MainActor
    func outputError(_ error: Error, message: String) {
        dependency.viewModel?.bannerMessgage = NotificationMessage(type: .onFailure, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    // MARK: - Private

    private var dependency: Dependency!

    private static let CFBundleShortVersionString = "CFBundleShortVersionString"

    /// ユーザーとルームをセットアップする
    private func setupUserAndRoom(
        userId: String, userName: String, roomId: Int
    ) async {
        currentUser = User(
            id: userId,
            name: userName,
            currentRoomId: roomId,
            selectedCardId: "")
        LocalStorage.shared.currentRoomId = roomId
        LocalStorage.shared.currentUserId = userId

        // 入力ルームIDに合致する既存ルームが存在するか確認
        let roomExist: Bool = await dependency.useCase.checkRoomExist(roomId: roomId)
        if roomExist {
            // 既存ルーム
            currentRoom.id = roomId
            await dependency.useCase.adduserToRoom(roomId: roomId, user: currentUser)
        } else {
            // 新規ルーム
            currentRoom = Room(
                id: roomId,
                userList: [currentUser],
                cardPackage: .defaultCardPackage)
            await dependency.useCase.createRoom(room: currentRoom)
        }
    }

    /// ボタンを無効にする
    @MainActor
    private func disableButton(_ disabled: Bool) {
        dependency.viewModel?.isButtonEnabled = !disabled
    }

    /// ローダーを表示する
    @MainActor
    private func showLoader(_ show: Bool) {
        dependency.viewModel?.isShownLoader = show
    }

    // MARK: - Router

    /// カード一覧画面に遷移する
    @MainActor
    private func pushCardListView() {
        dependency.viewModel?.willPushCardListView = true
    }
}
