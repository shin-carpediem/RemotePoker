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

    private var cancellables = Set<AnyCancellable>()

    /// 匿名ログインする(ユーザーIDを返却)
    private func signIn() -> Future<String, Never> {
        Future<String, Never> { [unowned self] promise in
            AuthDataStore.shared.signIn()
                .sink { userId in
                    promise(.success(userId))
                }
                .store(in: &cancellables)
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

    /// ユーザーに、存在するカレントルームがあるか確認する
    private func checkUserInCurrentRoom() async -> Bool {
        if dependency.roomId == 0 {
            return false
        } else {
            return await dependency.useCase.checkRoomExist(roomId: dependency.roomId)
        }
    }

    private func showTitle(userList: [UserViewModel]) {
        let otherUsersCount: Int = userList.count - 1
        let title = "\(dependency.currentUserName) \(otherUsersCount >= 1 ? "と \(String(otherUsersCount))名" : "")が ルームID\(dependency.roomId) に入室中"
        
        Task { @MainActor in
            dependency.viewModel?.title = title
        }
    }

    private func updateUserSelectStatusList(userList: [UserViewModel]) {
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

        Task { @MainActor in
            dependency.viewModel?.userSelectStatusList = userSelectStatusList
        }
    }

    private func showSelectedCardList() {
        Task { @MainActor in
            dependency.viewModel?.isShownSelectedCardList = true
        }
        disableButton(false)
        showLoader(false)
    }

    private func hideSelectedCardList() {
        Task { @MainActor in
            dependency.viewModel?.isShownSelectedCardList = false
        }
        disableButton(false)
        showLoader(false)
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

    private func pushSettingView() {
        Task { @MainActor in
            dependency.viewModel?.willPushSettingView = true
        }
    }
}

// MARK: - CardListPresentation

extension CardListPresenter: CardListPresentation {
    public func didSelectCard(cardId: String) {
        disableButton(true)
        dependency.useCase.updateSelectedCardId(selectedCardDictionary: [dependency.currentUserId: cardId])
    }

    public func didTapOpenSelectedCardListButton() {
        disableButton(true)
        showLoader(true)
        showSelectedCardList()
    }

    public func didTapBackButton() {
        disableButton(true)
        showLoader(true)
        hideSelectedCardList()
    }

    public func didTapSettingButton() {
        pushSettingView()
    }

    // MARK: - Presentation

    public func viewDidLoad() {
        disableButton(true)
        showLoader(true)
        
        Task {
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
    public func outputCurrentUser(_ user: UserModel) {
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

    public func outputUserList(_ userList: [UserModel]) {
        let viewModel = userList.map {
            UserViewModel(
                id: $0.id, name: $0.name, currentRoomId: $0.currentRoomId,
                selectedCardId: $0.selectedCardId)
        }
        Task { @MainActor in
            dependency.viewModel?.room.userList = viewModel
        }
        showTitle(userList: viewModel)
        updateUserSelectStatusList(userList: viewModel)
        disableButton(false)
        showLoader(false)
    }

    public func outputCardPackage(_ cardPackage: CardPackageModel) {
        Task { @MainActor in
            dependency.viewModel?.room.cardPackage = CardPackageModelToCardPackageViewModelTranslator()
                .translate(cardPackage)
        }
        disableButton(false)
        showLoader(false)
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
