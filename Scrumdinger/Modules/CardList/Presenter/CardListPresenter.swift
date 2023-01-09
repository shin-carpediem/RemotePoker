import Foundation

final class CardListPresenter: CardListPresentation, CardListInteractorOutput, DependencyInjectable {
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
            showHeaderTitle()
            updateUserSelectStatusList()
        }
    }

    func viewDidSuspend() {}
    
    // MARK: - CardListPresentation
    
    func didSelectCard(cardId: String) {
        disableButton(true)
        showLoader(true)
        let selectedCardDictionary: [String : String] = [dependency.currentUserId: cardId]
        dependency.useCase.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
    }
    
    func didTapOpenSelectedCardListButton() {
        disableButton(true)
        showLoader(true)
        showSelectedCardList()
    }
    
    func didTapResetSelectedCardListButton() {
        disableButton(true)
        showLoader(true)
        // カレントユーザーの選択済みカードをリセットする
        let selectedCardDictionary: [String: String] = [dependency.currentUserId: ""]
        dependency.useCase.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
        hideSelectedCardList()
    }
    
    func didTapSettingButton() {
        pushSettingView()
    }
    
    // MARK: - CardListInteractorOutput
    
    func outputRoom(_ room: Room) {
        Task { @MainActor in
            dependency.viewModel?.room = room
            disableButton(false)
            showLoader(false)
        }
    }
    
    func outputSuccess(message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = .init(type: .onSuccess, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
    
    func outputError(_ error: Error, message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = .init(type: .onFailure, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// ルームを要求する
    private func requestRoom() async {
        await dependency.useCase.requestRoom()
    }
    /// ヘッダーテキストを表示する
    private func showHeaderTitle() {
        Task { @MainActor in
            guard let room = dependency.viewModel?.room else { return }

            let currentUserName = dependency.currentUserName
            let otherUsersCount = room.userList.count - 1
            let roomId = dependency.roomId
            let only = otherUsersCount >= 1 ? "" : "only"
            let s = otherUsersCount >= 2 ? "s" : ""
            let otherUsersText = otherUsersCount >= 1 ? "and \(String(otherUsersCount)) guy\(s)" : ""
            
            let headerTitle = "\(only) \(currentUserName) \(otherUsersText) in Room \(roomId)"

            dependency.viewModel?.headerTitle = headerTitle
            disableButton(false)
            showLoader(false)
        }
    }
    
    /// ユーザーの選択状況一覧を更新する
    private func updateUserSelectStatusList() {
        Task { @MainActor in
            guard let room = dependency.viewModel?.room else { return }

            let userSelectStatusList: [UserSelectStatus] = room.userList.map { user in
                let cardPackage = room.cardPackage
                
                let id = Int.random(in: 0..<99999999)
                let themeColor = cardPackage.themeColor
                let selectedCard: Card? = cardPackage.cardList.first(where: { $0.id == user.selectedCardId })

                return UserSelectStatus(id: id,
                                        user: user,
                                        themeColor: themeColor,
                                        selectedCard: selectedCard)
            }
            
            dependency.viewModel?.userSelectStatusList = userSelectStatusList
            disableButton(false)
            showLoader(false)
        }
    }
    
    /// 選択されたカード一覧を表示する
    private func showSelectedCardList() {
        Task { @MainActor in
            dependency.viewModel?.isShownSelectedCardList = true
            disableButton(false)
            showLoader(false)
        }
    }
    
    /// 選択されたカード一覧を非表示にする
    private func hideSelectedCardList() {
        Task { @MainActor in
            dependency.viewModel?.isShownSelectedCardList = false
            disableButton(false)
            showLoader(false)
        }
    }
    
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isButtonEnabled = !disabled
        }
    }
    
    /// ローダーを表示する
    private func showLoader(_ show: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isShownLoader = show
        }
    }
    
    // MARK: - Router
    
    /// 設定画面に遷移する
    private func pushSettingView() {
        Task { @MainActor in
            dependency.viewModel?.willPushSettingView = true
            disableButton(false)
            showLoader(false)
        }
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
                showHeaderTitle()
                updateUserSelectStatusList()
            }

        case .modified:
            // ユーザーの選択済みカードが更新された時
            Task {
                await requestRoom()
                updateUserSelectStatusList()
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
