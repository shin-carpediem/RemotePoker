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
        dependency.useCase.activateRoomDelegate(self)
        dependency.useCase.subscribeUsers()
        dependency.useCase.subscribeCardPackages()
    }

    func viewDidResume() {
        Task {
            await requestRoom()
            await showHeaderTitle()
            await updateUserSelectStatusList()
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

    @MainActor func outputRoom(_ room: Room) {
        dependency.viewModel?.room = room
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

    /// ルームを要求する
    private func requestRoom() async {
        await dependency.useCase.requestRoom()
    }
    /// ヘッダーテキストを表示する
    @MainActor private func showHeaderTitle() {
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

    /// ユーザーの選択状況一覧を更新する
    @MainActor private func updateUserSelectStatusList() {
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

// MARK: - RoomDelegate

extension CardListPresenter: RoomDelegate {
    func whenUserChanged(action: UserAction) {
        switch action {
        case .added, .removed:
            // ユーザーが入室あるいは退室した時
            Task {
                await requestRoom()
                await showHeaderTitle()
                await updateUserSelectStatusList()
            }

        case .modified:
            // ユーザーの選択済みカードが更新された時
            Task {
                await requestRoom()
                await updateUserSelectStatusList()
            }

        case .unKnown:
            fatalError()
        }
    }

    func whenCardPackageChanged(action: CardPackageAction) {
        switch action {
        case .modified:
            // カードパッケージのテーマカラーが変更された時
            Task {
                await requestRoom()
            }

        case .added, .removed:
            ()

        case .unKnown:
            fatalError()
        }
    }
}
