import Foundation

class CardListPresenter: CardListPresentation {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var room: Room
        var currentUser: User
        var viewModel: CardListViewModel
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListPresentation
    
    func subscribeUser() {
        dependency.dataStore.subscribeUser()
    }
    
    func unsubscribeUser() {
        dependency.dataStore.unsubscribeUser()
    }
    
    func didSelectCard(card: Card) async {
        dependency.currentUser.selectedCardId = card.id
        dependency.dataStore.updateSelectedCardId(selectedCardDictionary: [dependency.currentUser.id: card.id])
        updateUserSelectStatus()
    }
    
    func didTapOpenSelectedCardListButton() {
        disableButton(true)
        showSelectedCardList(true)
    }
    
    func didTapResetSelectedCardListButton() async {
        disableButton(true)
        dependency.currentUser.selectedCardId = ""
        let userIdList: [String] = dependency.viewModel.userSelectStatus.map { $0.user.id }
        var selectedCardDictionary: [String: String] = [:]
        userIdList.forEach { userId in
            selectedCardDictionary[userId] = ""
        }
        dependency.dataStore.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
        updateUserSelectStatus()

        showSelectedCardList(false)
    }
    
    func didTapSettingButton() {
        pushSettingView()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonEnabled = !disabled
        }
    }
    
    private func showHeaderTitle() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let currentUserName = self.dependency.currentUser.name
            let otherUsersCount = self.dependency.room.userList.count - 1
            let roomId = self.dependency.room.id
            let only = otherUsersCount >= 1 ? "" : "only"
            let s = otherUsersCount >= 2 ? "s" : ""
            let otherUsersText = otherUsersCount >= 1 ? "and \(String(otherUsersCount)) guy\(s)" : ""
            
            let headerTitle = "\(only) \(currentUserName) \(otherUsersText) in Room: \(roomId)"

            self.dependency.viewModel.headerTitle = headerTitle
        }
    }
        
    private func showSelectedCardList(_ open: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isShownSelectedCardList = open
        }
    }

    private func updateUserSelectStatus() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let userSelectStatus: [UserSelectStatus] = self.dependency.room.userList.map { [weak self] user in
                // TODO: データの流れを明確にする
//                let selectedCardId: String = self!.dependency.dataStore.fetchUser(id: user.id).selectedCardId
                let selectedCardId: String = user.selectedCardId
                let selectedCard: Card = self!.dependency.dataStore.fetchCard(
                    cardPackageId: self!.dependency.room.cardPackage.id,
                    cardId: selectedCardId)

                return UserSelectStatus(id: Int.random(in: 0..<99999999),
                                        user: user,
                                        themeColor: self!.dependency.room.cardPackage.themeColor,
                                        selectedCard: selectedCard)
            }
            
            self.dependency.viewModel.userSelectStatus = userSelectStatus
        }
        disableButton(false)
    }
    
    // MARK: - Router
    
    private func pushSettingView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushSettingView = true
        }
        disableButton(false)
    }
}

// MARK: - RoomDelegate

extension CardListPresenter: RoomDelegate {
    func whenUserChanged(actionType: UserActionType) {
        switch actionType {
        case .added, .removed:
            // ユーザーが入室あるいは退室した時
            showHeaderTitle()
        case .modified:
            // ユーザーの選択済みカードが更新された時
            updateUserSelectStatus()
        case .unKnown:
            fatalError()
        }
    }
}
