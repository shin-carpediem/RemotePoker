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
    
    func outputHeaderTitle() -> String {
        let currentUserName = dependency.currentUser.name
        let otherUsersCount = dependency.room.userList.count - 1
        let roomId = dependency.room.id
        let only = otherUsersCount >= 1 ? "" : "only"
        let s = otherUsersCount >= 2 ? "s" : ""
        let otherUsersText = otherUsersCount >= 1 ? "and \(String(otherUsersCount)) guy\(s)" : ""
        
        let headerTitle = "\(only) \(currentUserName) \(otherUsersText) in Room: \(roomId)"
        dependency.viewModel.headerTitle = headerTitle
        return headerTitle
    }
    
    func subscribeUser() {
        dependency.dataStore.subscribeUser()
    }
    
    func didSelectCard(card: Card) async {
        dependency.currentUser.selectedCard = card
        let userSelectStatus = UserSelectStatus(id: Int.random(in: 0..<99999999),
                                                user: dependency.currentUser,
                                                themeColor: dependency.room.cardPackage.themeColor,
                                                selectedCard: card)
        dependency.viewModel.userSelectStatus.append(userSelectStatus)
        await dependency.dataStore.updateSelectedCard(userId: dependency.currentUser.id,
                                                   selectedCard: card)
    }
    
    func outputUserSelectStatus() -> [UserSelectStatus] {
        let userSelectStatus: [UserSelectStatus] = dependency.room.userList.map { user in
            return UserSelectStatus(id: Int.random(in: 0..<99999999),
                                    user: user,
                                    themeColor: dependency.room.cardPackage.themeColor,
                                    selectedCard: user.selectedCard ?? nil)
        }
        
        dependency.viewModel.userSelectStatus = userSelectStatus
        return userSelectStatus
    }
    
    func openSelectedCardList() {
        dependency.viewModel.isOpenSelectedCardList = true
        dependency.viewModel.willPushNextView = true
    }
    
    func resetSelectedCardList() async {
        dependency.viewModel.userSelectStatus.removeAll()
        await dependency.dataStore.removeSelectedCardFromAllUsers()
        dependency.viewModel.isOpenSelectedCardList = false
        dependency.viewModel.willPushNextView = false
    }
    
    func leaveRoom() async {
        await dependency.dataStore.removeUserFromRoom(userId: dependency.currentUser.id)
    }
    
    func unsubscribeUser() {
        dependency.dataStore.unsubscribeUser()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}

// MARK: - RoomDelegate

extension CardListPresenter: RoomDelegate {
    func whenUserAdded() {
        dependency.viewModel.headerTitle = outputHeaderTitle()
    }
    
    func whenUserModified() {
        // 選択されたカード一覧を更新する
        let room = dependency.room
        dependency.viewModel.userSelectStatus = outputUserSelectStatus()
    }
    
    func whenUserRemoved() {
        dependency.viewModel.headerTitle = outputHeaderTitle()
    }
}
