import Combine
import Foundation

final class CardListPresenter: CardListPresentation, CardListInteractorOutput, DependencyInjectable
{
    // MARK: - DependencyInjectable

    struct Dependency {
        var useCase: CardListUseCase
        var roomId: Int
        var currentUserId: String
        var currentUserName: String
        var isExisingUser: Bool
        weak var viewModel: CardListViewModel?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - CardListPresentation

    func viewDidLoad() {
        Task {
            await disableButton(true)
            await showLoader(true)
            if dependency.isExisingUser {
                // 既存ユーザー（この画面が初期画面）
                self.signIn()
            } else {
                // 新規ユーザー（EnterRoom画面が初期画面）
                await self.sucscribeAndSetupData(
                    userId: dependency.currentUserId, shouldFetchData: self.dependency.isExisingUser
                )
            }
        }
    }

    func viewDidResume() {}

    func viewDidSuspend() {}

    func didSelectCard(cardId: String) {
        Task {
            await disableButton(true)
            let selectedCardDictionary: [String: String] = [dependency.currentUserId: cardId]
            dependency.useCase.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
        }
    }

    func didTapOpenSelectedCardListButton() {
        Task {
            await disableButton(true)
            await showLoader(true)
            await showSelectedCardList()
        }
    }

    func didTapResetSelectedCardListButton() {
        Task {
            await disableButton(true)
            await showLoader(true)
            // カレントユーザーの選択済みカードをリセットする
            let selectedCardDictionary: [String: String] = [dependency.currentUserId: ""]
            dependency.useCase.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
            await hideSelectedCardList()
        }
    }

    func didTapSettingButton() {
        Task {
            await pushSettingView()
        }
    }

    // MARK: - CardListInteractorOutput

    @MainActor
    func outputCurrentUser(_ user: UserModel) {
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

    @MainActor
    func outputUserList(_ userList: [UserModel]) {
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

    @MainActor
    func outputCardPackage(_ cardPackage: CardPackageModel) {
        dependency.viewModel?.room.cardPackage = translator.translate(cardPackage)
        disableButton(false)
        showLoader(false)
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

    private var cancellablesForAction = Set<AnyCancellable>()

    private let translator = CardPackageModelToCardPackageViewModelTranslator()

    /// 匿名ログインする
    private func signIn() {
        AuthDataStore.shared.signIn()
            .sink { userId in
                Task { [weak self] in
                    guard let self = self else { return }
                    // ユーザーのカレントルームがFirestore上に存在するか確認する
                    if await self.checkUserInCurrentRoom() {
                        await self.sucscribeAndSetupData(
                            userId: userId, shouldFetchData: self.dependency.isExisingUser)
                    }
                }
            }
            .store(in: &self.cancellablesForAction)
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

    /// タイトルを表示する
    @MainActor
    private func showTitle(userList: [UserViewModel]) {
        let currentUserName: String = dependency.currentUserName
        let otherUsersCount: Int = userList.count - 1
        let otherUsersText = (otherUsersCount >= 1 ? "と \(String(otherUsersCount))名" : "")
        let roomId: Int = dependency.roomId

        let title = "\(currentUserName) \(otherUsersText)が ルームID\(roomId) に入室中"
        dependency.viewModel?.title = title
    }

    /// ユーザーの選択状況一覧を更新する
    @MainActor
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
        dependency.viewModel?.userSelectStatusList = userSelectStatusList
    }

    /// 選択されたカード一覧を表示する
    @MainActor
    private func showSelectedCardList() {
        dependency.viewModel?.isShownSelectedCardList = true
        disableButton(false)
        showLoader(false)
    }

    /// 選択されたカード一覧を非表示にする
    @MainActor
    private func hideSelectedCardList() {
        dependency.viewModel?.isShownSelectedCardList = false
        disableButton(false)
        showLoader(false)
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

    /// 設定画面に遷移する
    @MainActor
    private func pushSettingView() {
        dependency.viewModel?.willPushSettingView = true
    }
}
