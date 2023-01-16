import Foundation

final class CardListPresenter: CardListPresentation, CardListInteractorOutput, DependencyInjectable
{
    // MARK: - DependencyInjectable

    struct Dependency {
        var useCase: CardListUseCase
        var roomId: Int
        var currentUserId: String
        var currentUserName: String
        weak var viewModel: CardListViewModel?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Presentation

    func viewDidLoad() {
        Task {
            await disableButton(true)
            await showLoader(true)
            if RoomAuthDataStore.shared.isUsrLoggedIn {
                // 新規ユーザー（EnterRoom画面が初期画面）
                if let userId = RoomAuthDataStore.shared.fetchUserId() {
                    await self.setupData(userId: userId)
                }
            } else {
                // 既存ユーザー（この画面が初期画面）
                self.login()
            }
        }
    }

    func viewDidResume() {
        Task {
            await disableButton(true)
            await showLoader(true)
            if RoomAuthDataStore.shared.isUsrLoggedIn {
                // 新規ユーザー（EnterRoom画面が初期画面）
                if let userId = RoomAuthDataStore.shared.fetchUserId() {
                    await self.setupData(userId: userId)
                }
            } else {
                // 既存ユーザー（この画面が初期画面）
                self.login()
            }
        }
    }

    func viewDidSuspend() {}

    // MARK: - CardListPresentation

    func didSelectCard(cardId: String) {
        Task {
            await disableButton(true)
            await showLoader(true)
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

    func outputUser(_ user: User) {
        Task {
            dependency.currentUserId = user.id
            dependency.currentUserName = user.name
            await disableButton(false)
            await showLoader(false)
        }
    }

    @MainActor func outputRoom(_ room: Room) {
        dependency.viewModel?.room = room
        disableButton(false)
        showLoader(false)
    }

    @MainActor func showHeaderTitle() {
        guard let room = dependency.viewModel?.room else { return }

        let currentUserName = dependency.currentUserName
        let otherUsersCount = room.userList.count - 1
        let roomId = dependency.roomId
        let otherUsersText = (otherUsersCount >= 1 ? "と \(String(otherUsersCount))名" : "")

        let headerTitle = "\(currentUserName) \(otherUsersText)が ルームID\(roomId) に入室中"

        dependency.viewModel?.headerTitle = headerTitle
        disableButton(false)
        showLoader(false)
    }

    @MainActor func updateUserSelectStatusList() {
        guard let room = dependency.viewModel?.room else { return }

        let userSelectStatusList: [UserSelectStatus] = room.userList.map { user in
            let cardPackage = room.cardPackage

            let id = Int.random(in: 0..<99_999_999)
            let themeColor = cardPackage.themeColor
            let selectedCard: Card? = cardPackage.cardList.first(where: {
                $0.id == user.selectedCardId
            })

            return UserSelectStatus(
                id: id,
                user: user,
                themeColor: themeColor,
                selectedCard: selectedCard)
        }

        dependency.viewModel?.userSelectStatusList = userSelectStatusList
        disableButton(false)
        showLoader(false)
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

    /// 匿名ログインする
    private func login() {
        RoomAuthDataStore.shared.login { [weak self] result in
            guard let self = self else { return }
            Task {
                switch result {
                case .success(let userId):
                    // ログインに成功した
                    await self.setupData(userId: userId)

                case .failure(let error):
                    // ログインに失敗した
                    let message = "ログインできませんでした。アプリを再インストールしてください"
                    await self.outputError(error, message: message)
                }
            }
        }
    }

    /// 各種データをセットアップする
    private func setupData(userId: String) async {
        dependency.useCase.requestUser(userId: userId)
        // ユーザーのカレントルームがFirestore上に存在するか確認する
        if await checkUserInCurrentRoom() {
            // 存在する場合
            // ルームリポジトリにルームIDをセットし、各種データの購読を開始する
            dependency.useCase.setupRoomRepository(roomId: dependency.roomId)
            dependency.useCase.subscribeUsers()
            dependency.useCase.subscribeCardPackages()
            await requestRoom()
            await showHeaderTitle()
            await updateUserSelectStatusList()
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

    /// ルームを要求する
    private func requestRoom() async {
        await dependency.useCase.requestRoom()
    }

    /// 選択されたカード一覧を表示する
    @MainActor private func showSelectedCardList() {
        dependency.viewModel?.isShownSelectedCardList = true
        disableButton(false)
        showLoader(false)
    }

    /// 選択されたカード一覧を非表示にする
    @MainActor private func hideSelectedCardList() {
        dependency.viewModel?.isShownSelectedCardList = false
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

    /// 設定画面に遷移する
    @MainActor private func pushSettingView() {
        dependency.viewModel?.willPushSettingView = true
        disableButton(false)
        showLoader(false)
    }
}
