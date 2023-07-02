import Foundation
import Model
import Protocols
import RemotePokerData
import Translator
import ViewModel

public final class EnterRoomPresenter: EnterRoomPresentation,
    DependencyInjectable
{
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var useCase: EnterRoomUseCase
        public weak var viewModel: EnterRoomViewModel?

        public init(useCase: EnterRoomUseCase, viewModel: EnterRoomViewModel?) {
            self.useCase = useCase
            self.viewModel = viewModel
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - EnterRoomPresentation

    public var currentUser = UserViewModel(
        id: "",
        name: "",
        currentRoomId: 0,
        selectedCardId: "")

    public lazy var currentRoom = RoomViewModel(
        id: 0, userList: [], cardPackage: translator.translate(.defaultCardPackage))

    public func didTapEnterRoomButton(inputUserName: String, inputRoomId: String) {
        if let viewModel: EnterRoomViewModel = dependency.viewModel,
            viewModel.isInputFormValid
        {
            disableButton(true)
            showLoader(true)

            Task {
                guard let roomId = Int(inputRoomId) else {
                    fatalError()
                }
                await dependency.useCase.signIn(userName: inputUserName, roomId: roomId)
            }
        }
    }

    // MARK: - Presentation

    public func viewDidLoad() {}

    public func viewDidResume() {}

    public func viewDidSuspend() {}

    // MARK: - Private

    private var dependency: Dependency!

    private static let CFBundleShortVersionString = "CFBundleShortVersionString"

    private let translator = CardPackageModelToCardPackageViewModelTranslator()

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

    private func disableButton(_ disabled: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isButtonEnabled = !disabled
        }
    }

    private func showLoader(_ show: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isShownLoader = show
        }
    }

    // MARK: - Router

    private func pushCardListView() {
        Task { @MainActor in
            dependency.viewModel?.willPushCardListView = true
        }
    }
}

// MARK: - EnterRoomInteractorOutput

extension EnterRoomPresenter: EnterRoomInteractorOutput {
    public func outputSucceedToSignIn(userId: String, userName: String, roomId: Int) {
        Task { @MainActor in
            await setupUserAndRoom(userId: userId, userName: userName, roomId: roomId)
            disableButton(false)
            showLoader(false)
            pushCardListView()
        }
    }

    public func outputSuccess(message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onSuccess, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }

    public func outputError(_ error: Error, message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onFailure, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
}
