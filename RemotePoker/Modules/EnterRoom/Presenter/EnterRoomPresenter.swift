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
    
    var currentUser = UserViewModel(
        id: "",
        name: "",
        currentRoomId: 0,
        selectedCardId: "")

    lazy var currentRoom = RoomViewModel(
        id: 0, userList: [], cardPackage: translator.translate(.defaultCardPackage))

    func didTapEnterRoomButton(inputUserName: String, inputRoomId: String) {
        Task {
            await disableButton(true)
            if let viewModel: EnterRoomViewModel = dependency.viewModel,
                await viewModel.isInputFormValid
            {
                // フォーム内容が有効
                await showLoader(true)
                let roomId = Int(inputRoomId)!
                await dependency.useCase.signIn(userName: inputUserName, roomId: roomId)
            } else {
                // フォーム内容が有効ではない
            }
            await disableButton(false)
            await showLoader(false)
        }
    }
    
    // MARK: - Presentation

    func viewDidLoad() {}

    func viewDidResume() {}

    func viewDidSuspend() {}

    // MARK: - EnterRoomInteractorOutput

    func outputCompletedSignIn(userId: String, userName: String, roomId: Int) {
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

    private let translator = CardPackageModelToCardPackageViewModelTranslator()

    /// ユーザーとルームをセットアップする
    private func setupUserAndRoom(
        userId: String, userName: String, roomId: Int
    ) async {
        currentUser = UserViewModel(
            id: userId,
            name: userName,
            currentRoomId: roomId,
            selectedCardId: "")
        LocalStorage.shared.currentRoomId = roomId
        LocalStorage.shared.currentUserId = userId

        let currentUserModel = UserModel(
            id: currentUser.id, name: currentUser.name, currentRoomId: currentUser.currentRoomId,
            selectedCardId: currentUser.selectedCardId)
        // 入力ルームIDに合致する既存ルームが存在するか確認
        let roomExist: Bool = await dependency.useCase.checkRoomExist(roomId: roomId)
        if roomExist {
            // 既存ルーム
            currentRoom.id = roomId
            await dependency.useCase.adduserToRoom(roomId: roomId, user: currentUserModel)
        } else {
            // 新規ルーム
            currentRoom = RoomViewModel(
                id: roomId,
                userList: [currentUser],
                cardPackage: translator.translate(.defaultCardPackage))

            let currentRoomModel = RoomModel(
                id: currentRoom.id,
                userList: currentRoom.userList.map {
                    UserModel(
                        id: $0.id, name: $0.name, currentRoomId: $0.currentRoomId,
                        selectedCardId: $0.selectedCardId)
                },
                cardPackage: CardPackageModel(
                    id: currentRoom.cardPackage.id,
                    themeColor: currentRoom.cardPackage.themeColor.rawValue,
                    cardList: currentRoom.cardPackage.cardList.map {
                        CardPackageModel.Card(id: $0.id, point: $0.point, index: $0.index)
                    }))

            await dependency.useCase.createRoom(room: currentRoomModel)
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
