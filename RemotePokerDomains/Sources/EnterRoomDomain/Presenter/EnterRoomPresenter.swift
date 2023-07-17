import Foundation
import Model
import Protocols
import RemotePokerData
import Shared
import Translator
import ViewModel

public final class EnterRoomPresenter: DependencyInjectable
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

    private var dependency: Dependency!

    private static let CFBundleShortVersionString = "CFBundleShortVersionString"

    private let translator = CardPackageModelToViewModelTranslator()
}

// MARK: - EnterRoomPresentation

extension EnterRoomPresenter: EnterRoomPresentation {
    public func didTapEnterRoomButton(inputUserName: String, inputRoomId: String) {
        if let viewModel: EnterRoomViewModel = dependency.viewModel,
            viewModel.isInputFormValid
        {
            updateButtons(isEnabled: false)
            updateLoader(isShown: true)

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
}

// MARK: - EnterRoomInteractorOutput

extension EnterRoomPresenter: EnterRoomInteractorOutput {
    public func outputSucceedToSignIn(userId: String, userName: String, roomId: Int) {
        Task { @MainActor in
            await setupUserAndRoom(userId: userId, userName: userName, roomId: roomId)
            updateButtons(isEnabled: true)
            updateLoader(isShown: false)
            pushCardListView()
        }
    }

    public func outputSuccess(message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onSuccess, text: message)
            dependency.viewModel?.isBannerShown = true
        }
    }

    public func outputError(_ error: Error, message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onFailure, text: message)
            dependency.viewModel?.isBannerShown = true
        }
    }
}

// MARK: - Private

extension EnterRoomPresenter {
    // TODO: やってる事が多すぎるので、整理する
    private func setupUserAndRoom(
        userId: String, userName: String, roomId: Int
    ) async {
        let currentUser = UserModel(
            id: userId,
            name: userName,
            selectedCardId: "")
        await dependency.useCase.createUser(currentUser)
        
        let currentRoom = CurrentRoomModel(
            id: roomId,
            userList: [currentUser],
            cardPackage: .defaultCardPackage)

        AppConfigManager.appConfig = .init(
            currentUser: currentUser,
            currentRoom: currentRoom)

        LocalStorage.shared.currentUserId = userId
        LocalStorage.shared.currentRoomId = roomId
        
        // 入力ルームIDに合致する既存ルームが存在するか確認
        if await dependency.useCase.checkRoomExist(by: roomId) {
            // 既存ルーム
            AppConfigManager.appConfig?.currentRoom.id = roomId
            await dependency.useCase.adduserToRoom(roomId: roomId, userId: userId)
        } else {
            // 新規ルーム
            AppConfigManager.appConfig?.currentRoom = CurrentRoomModel(
                id: roomId,
                userList: [currentUser],
                cardPackage: .defaultCardPackage)

            let currentRoomModel = RoomModel(
                id: currentRoom.id,
                userIdList: [userId],
                cardPackage: CardPackageModel(
                    id: currentRoom.cardPackage.id,
                    themeColor: currentRoom.cardPackage.themeColor,
                    cardList: currentRoom.cardPackage.cardList.map {
                        CardPackageModel.Card(id: $0.id, estimatePoint: $0.estimatePoint, index: $0.index)
                    }))

            await dependency.useCase.createRoom(currentRoomModel)
        }
    }

    private func updateButtons(isEnabled: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isButtonsEnabled = isEnabled
        }
    }

    private func updateLoader(isShown: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isLoaderShown = isShown
        }
    }

    private func pushCardListView() {
        Task { @MainActor in
            dependency.viewModel?.willPushCardListView = true
        }
    }
}
