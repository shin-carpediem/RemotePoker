import Combine
import Foundation
import Model
import Protocols
import RemotePokerData
import Translator
import ViewModel

public final class CardListPresenter: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var useCase: CardListUseCase
        public var roomId: Int
        public var currentUserId: String
        public var currentUserName: String
        public var isExisingUser: Bool
        public weak var viewModel: CardListViewModel?

        public init(
            useCase: CardListUseCase, roomId: Int, currentUserId: String, currentUserName: String,
            isExisingUser: Bool, viewModel: CardListViewModel?
        ) {
            self.useCase = useCase
            self.roomId = roomId
            self.currentUserId = currentUserId
            self.currentUserName = currentUserName
            self.isExisingUser = isExisingUser
            self.viewModel = viewModel
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Private

    private var dependency: Dependency!

    private var cancellablesForAction = Set<AnyCancellable>()

    /// 匿名ログインする(ユーザーIDを返却)
    private func signIn() -> Future<String, Never> {
        Future<String, Never> { [unowned self] promise in
            AuthDataStore.shared.signIn()
                .sink { userId in
                    promise(.success(userId))
                }
                .store(in: &cancellablesForAction)
        }
    }

    /// 各種データを購読しセットアップする
    private func sucscribeAndSetupData(userId: String, shouldFetchData: Bool) async {
        dependency.useCase.subscribeUsers()
        dependency.useCase.subscribeCardPackages()
        if shouldFetchData {
            await dependency.useCase.requestUser(userId: userId)
        }
    }

    private func checkUserInCurrentRoom() async -> Bool {
        if dependency.roomId == 0 {
            return false
        } else {
            return await dependency.useCase.checkRoomExist(roomId: dependency.roomId)
        }
    }

    @MainActor private func showTitle(userList: [UserViewModel]) {
        let otherUsersCount: Int = userList.count - 1
        let title = "\(dependency.currentUserName) \(otherUsersCount >= 1 ? "と \(String(otherUsersCount))名" : "")が ルームID\(dependency.roomId) に入室中"

        dependency.viewModel?.title = title
    }

    @MainActor private func updateUserSelectStatusList(userList: [UserViewModel]) {
        let userSelectStatusList: [UserSelectStatusViewModel] = userList.map { user in
            guard let cardPackage: CardPackageViewModel = dependency.viewModel?.room.cardPackage
            else {
                fatalError()
            }
            let selectedCard: CardPackageViewModel.Card? = cardPackage.cardList.first(where: {
                $0.id == user.selectedCardId
            })
            return UserSelectStatusViewModel(
                id: UUID().uuidString,
                user: user,
                themeColor: cardPackage.themeColor,
                selectedCard: selectedCard)
        }
        dependency.viewModel?.userSelectStatusList = userSelectStatusList
    }

    @MainActor private func showSelectedCardList() {
        dependency.viewModel?.isShownSelectedCardList = true
        disableButton(false)
        showLoader(false)
    }

    @MainActor private func hideSelectedCardList() {
        dependency.viewModel?.isShownSelectedCardList = false
        disableButton(false)
        showLoader(false)
    }

    @MainActor private func disableButton(_ disabled: Bool) {
        dependency.viewModel?.isButtonEnabled = !disabled
    }

    @MainActor private func showLoader(_ show: Bool) {
        dependency.viewModel?.isShownLoader = show
    }

    // MARK: - Router

    @MainActor private func pushSettingView() {
        dependency.viewModel?.willPushSettingView = true
    }
}

// MARK: - CardListPresentation

extension CardListPresenter: CardListPresentation {
    public func didSelectCard(cardId: String) {
        Task {
            await disableButton(true)
            let selectedCardDictionary: [String: String] = [dependency.currentUserId: cardId]
            dependency.useCase.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
        }
    }

    public func didTapOpenSelectedCardListButton() {
        Task {
            await disableButton(true)
            await showLoader(true)
            await showSelectedCardList()
        }
    }

    public func didTapBackButton() {
        Task {
            await disableButton(true)
            await showLoader(true)
            await hideSelectedCardList()
        }
    }

    public func didTapSettingButton() {
        Task {
            await pushSettingView()
        }
    }

    // MARK: - Presentation

    public func viewDidLoad() {
        Task {
            await disableButton(true)
            await showLoader(true)
            if dependency.isExisingUser {
                // 既存ユーザー（この画面が初期画面）
                let userId: String = await signIn().value
                // ユーザーのカレントルームがFirestore上に存在するか確認する
                if await checkUserInCurrentRoom() {
                    await sucscribeAndSetupData(
                        userId: userId, shouldFetchData: dependency.isExisingUser)
                }
            } else {
                // 新規ユーザー（EnterRoom画面が初期画面）
                await sucscribeAndSetupData(
                    userId: dependency.currentUserId, shouldFetchData: dependency.isExisingUser
                )
            }
        }
    }

    public func viewDidResume() {}

    public func viewDidSuspend() {}
}

// MARK: - CardListInteractorOutput

extension CardListPresenter: CardListInteractorOutput {
    @MainActor public func outputCurrentUser(_ user: UserModel) {
        dependency.currentUserId = user.id
        dependency.currentUserName = user.name
        let userList: [UserViewModel]? = dependency.viewModel?.room.userList.map {
            UserViewModel(
                id: $0.id, name: $0.name, currentRoomId: $0.currentRoomId,
                selectedCardId: $0.selectedCardId)
        }
        if let userList = userList {
            showTitle(userList: userList)
            updateUserSelectStatusList(userList: userList)
        }
        disableButton(false)
        showLoader(false)
    }

    @MainActor public func outputUserList(_ userList: [UserModel]) {
        let viewModel = userList.map {
            UserViewModel(
                id: $0.id, name: $0.name, currentRoomId: $0.currentRoomId,
                selectedCardId: $0.selectedCardId)
        }
        dependency.viewModel?.room.userList = viewModel
        showTitle(userList: viewModel)
        updateUserSelectStatusList(userList: viewModel)
        disableButton(false)
        showLoader(false)
    }

    @MainActor public func outputCardPackage(_ cardPackage: CardPackageModel) {
        dependency.viewModel?.room.cardPackage = CardPackageModelToCardPackageViewModelTranslator()
            .translate(cardPackage)
        disableButton(false)
        showLoader(false)
    }

    @MainActor public func outputSuccess(message: String) {
        dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
            type: .onSuccess, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    @MainActor public func outputError(_ error: Error, message: String) {
        dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
            type: .onFailure, text: message)
        dependency.viewModel?.isShownBanner = true
    }
}
