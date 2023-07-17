import Combine
import Foundation
import Model
import Protocols
import RemotePokerData
import Shared
import Translator
import ViewModel

public final class CardListPresenter: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var useCase: CardListUseCase
        public var isExisingUser: Bool
        public weak var viewModel: CardListViewModel?

        public init(
            useCase: CardListUseCase, isExisingUser: Bool, viewModel: CardListViewModel?
        ) {
            self.useCase = useCase
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
    
    private var appConfig: AppConfig {
        guard let appConfig = AppConfigManager.appConfig else {
            fatalError()
        }
        return appConfig
    }
}

// MARK: - CardListPresentation

extension CardListPresenter: CardListPresentation {
    public func didSelectCard(cardId: String) {
        updateButtons(isEnabled: false)

        dependency.useCase.updateSelectedCardId(selectedCardDictionary: [appConfig.currentUser.id: cardId])

        updateButtons(isEnabled: false)
    }

    public func didTapOpenSelectedCardListButton() {
        updateButtons(isEnabled: false)
        updateLoader(isShown: true)

        updateSelectedCardList(isShown: true)

        updateButtons(isEnabled: true)
        updateLoader(isShown: false)
    }

    public func didTapBackButton() {
        updateButtons(isEnabled: false)
        updateLoader(isShown: true)

        updateSelectedCardList(isShown: false)

        updateButtons(isEnabled: true)
        updateLoader(isShown: false)
    }

    public func didTapSettingButton() {
        pushSettingView()
    }

    // MARK: - Presentation

    public func viewDidLoad() {
        updateButtons(isEnabled: false)
        updateLoader(isShown: true)
        
        Task {
            if dependency.isExisingUser {
                // 既存ユーザー（この画面が初期画面）
                _ = try await signIn().value
                // ユーザーのカレントルームがFirestore上に存在するか確認する
                if await checkUserInCurrentRoom() {
                    await subscribeCurrentRoom(shouldFetchData: true)
                }
            } else {
                // 新規ユーザー（EnterRoom画面が初期画面）
                await subscribeCurrentRoom(shouldFetchData: false)
            }
        }
        
        updateButtons(isEnabled: true)
        updateLoader(isShown: false)
    }

    public func viewDidResume() {}

    public func viewDidSuspend() {}
}

// MARK: - CardListInteractorOutput

extension CardListPresenter: CardListInteractorOutput {
    public func outputCurrentUser(_ user: UserModel) {
        AppConfigManager.appConfig?.currentUser.id = user.id
        AppConfigManager.appConfig?.currentUser.name = user.name
    }

    public func outputRoom(_ room: CurrentRoomModel) {
        Task { @MainActor in
            let userList: [UserViewModel] = room.userList.map {
                UserViewModel(id: $0.id, name: $0.name, selectedCardId: $0.selectedCardId)
            }
            let cardPackage: CardPackageViewModel = CardPackageModelToViewModelTranslator()
                .translate(room.cardPackage)
            dependency.viewModel?.room = CurrentRoomViewModel(id: room.id, userList: userList, cardPackage: cardPackage)
            
            showTitle(userList: userList)
            updateUserSelectStatusList(userList: userList)
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

extension CardListPresenter {
    /// サインイン(匿名ログイン)する(ユーザーIDを返却)
    private func signIn() -> Future<String, Error> {
        Future<String, Error> { [unowned self] promise in
            AuthDataStore.shared.signIn()
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.outputError(error, message: "サインインできませんでした")
                        
                    case .finished:
                        ()
                    }
                }, receiveValue: { userId in
                    promise(.success(userId))
                })
                .store(in: &cancellables)
        }
    }

    /// カレントルームを購読しセットアップする
    private func subscribeCurrentRoom(shouldFetchData: Bool) async {
        dependency.useCase.subscribeCurrentRoom()
        if shouldFetchData {
            await dependency.useCase.requestUser()
        }
    }

    /// ユーザーに、存在するカレントルームがあるか確認する
    private func checkUserInCurrentRoom() async -> Bool {
        if appConfig.currentRoom.id == 0 {
            return false
        } else {
            return await dependency.useCase.checkRoomExist(roomId: appConfig.currentRoom.id)
        }
    }

    private func showTitle(userList: [UserViewModel]) {
        let otherUsersCount: Int = userList.count - 1
        let title = "\(appConfig.currentUser.name) \(otherUsersCount >= 1 ? "と \(String(otherUsersCount))名" : "")が ルームID\(appConfig.currentRoom.id) に入室中"
        
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
    
    private func updateSelectedCardList(isShown: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isShownSelectedCardList = isShown
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

    private func pushSettingView() {
        Task { @MainActor in
            dependency.viewModel?.willPushSettingView = true
        }
    }
}
