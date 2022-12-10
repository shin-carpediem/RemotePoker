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
//        let userSelectStatus = UserSelectStatus(id: Int.random(in: 0..<99999999),
//                                                user: dependency.currentUser,
//                                                themeColor: dependency.room.cardPackage.themeColor,
//                                                selectedCard: card)
        await dependency.dataStore.updateSelectedCard(userId: dependency.currentUser.id,
                                                      selectedCard: card)
        updateUserSelectStatus()
    }
    
    func didTapOpenSelectedCardListButton() {
        disableSendButton(true)
        switchOpenSelectedCardListStatus(true)
        pushNextView(true)
    }
    
    func didTapResetSelectedCardListButton() async {
        disableSendButton(true)
        await dependency.dataStore.removeSelectedCardFromAllUsers()
        updateUserSelectStatus()

        switchOpenSelectedCardListStatus(false)
        pushNextView(false)
    }
    
    func didTapLeaveRoomButton() async {
        disableSendButton(true)
        await dependency.dataStore.removeUserFromRoom(userId: dependency.currentUser.id)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    private func disableSendButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonAbled = !disabled
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
        
    private func switchOpenSelectedCardListStatus(_ open: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isOpenSelectedCardList = !open
        }
    }

    private func updateUserSelectStatus() {
        disableSendButton(false)
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
    }
    
    // MARK: - Router
    
    private func pushNextView(_ willPush: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushNextView = willPush
        }
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
