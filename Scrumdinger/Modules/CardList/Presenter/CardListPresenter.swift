import Foundation

final class CardListPresenter: CardListPresentation, CardListInteractorOutput, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var useCase: CardListUseCase
        var room: Room
        var currentUser: User
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
            applyThemeColor()
            showHeaderTitle()
            updateUserSelectStatusList()
        }
    }

    func viewDidSuspend() {}
    
    // MARK: - CardListPresentation
    
    func didSelectCard(card: Card) {
        disableButton(true)
        let selectedCardDictionary: [String : String] = [dependency.currentUser.id: card.id]
        dependency.useCase.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
    }
    
    func didTapOpenSelectedCardListButton() {
        disableButton(true)
        showSelectedCardList()
    }
    
    func didTapResetSelectedCardListButton() {
        disableButton(true)
        // カレントユーザーの選択済みカードをリセットする
        let selectedCardDictionary: [String: String] = [dependency.currentUser.id: ""]
        dependency.useCase.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
        hideSelectedCardList()
    }
    
    func didTapSettingButton() {
        pushSettingView()
    }
    
    // MARK: - CardListInteractorOutput
    
    func outputRoom(_ room: Room) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.room = room
        }
    }
    
    func outputSuccess() {}
    
    func outputError(_ error: Error) {}
    
    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// ルームを要求する
    private func requestRoom() async {
        await dependency.useCase.requestRoom()
    }
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isButtonEnabled = !disabled
        }
    }
    
    /// テーマカラーを適用する
    private func applyThemeColor() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.dependency.viewModel?.room?.cardPackage.themeColor = self.dependency.room.cardPackage.themeColor
        }
    }
    
    /// ヘッダーテキストを表示する
    private func showHeaderTitle() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let room = self.dependency.viewModel?.room else { return }

            let currentUserName = self.dependency.currentUser.name
            let otherUsersCount = room.userList.count - 1
            let roomId = self.dependency.room.id
            let only = otherUsersCount >= 1 ? "" : "only"
            let s = otherUsersCount >= 2 ? "s" : ""
            let otherUsersText = otherUsersCount >= 1 ? "and \(String(otherUsersCount)) guy\(s)" : ""
            
            let headerTitle = "\(only) \(currentUserName) \(otherUsersText) in Room \(roomId)"

            self.dependency.viewModel?.headerTitle = headerTitle
        }
    }
    
    /// ユーザーの選択状況一覧を更新する
    private func updateUserSelectStatusList() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let room = self.dependency.viewModel?.room else { return }

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
            
            self.dependency.viewModel?.userSelectStatusList = userSelectStatusList
            self.disableButton(false)
        }
    }
    
    /// 選択されたカード一覧を表示する
    private func showSelectedCardList() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownSelectedCardList = true
            self?.disableButton(false)
        }
    }
    
    /// 選択されたカード一覧を非表示にする
    private func hideSelectedCardList() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownSelectedCardList = false
            self?.disableButton(false)
        }
    }
    
    // MARK: - Router
    
    /// 設定画面に遷移する
    private func pushSettingView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.willPushSettingView = true
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
                applyThemeColor()
            }

        case .added, .removed:
            ()

        case .unKnown:
            fatalError()
        }
    }
}
