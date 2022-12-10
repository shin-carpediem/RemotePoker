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
        dependency.currentUser.selectedCard = card
        await dependency.dataStore.updateSelectedCard(userId: dependency.currentUser.id,
                                                      selectedCard: card)
        updateUserSelectStatus()
    }
    
    func didTapOpenSelectedCardListButton() {
        disableButton(true)
        showSelectedCardList(true)
    }
    
    func didTapResetSelectedCardListButton() async {
        disableButton(true)
        await dependency.dataStore.removeSelectedCardFromAllUsers()
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
            let userSelectStatus: [UserSelectStatus] = self.dependency.room.userList.map { user in
                return UserSelectStatus(id: Int.random(in: 0..<99999999),
                                        user: user,
                                        themeColor: self.dependency.room.cardPackage.themeColor,
                                        selectedCard: user.selectedCard ?? nil)
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
            showHeaderTitle()
        case .modified:
            updateUserSelectStatus()
        case .unKnown:
            fatalError()
        }
    }
}
