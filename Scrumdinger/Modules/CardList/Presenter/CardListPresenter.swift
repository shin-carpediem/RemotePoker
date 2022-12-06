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
    
    func outputHeaderTitle() {
        let currentUserName = dependency.currentUser.name
        let otherUsersCount = dependency.room.userList.count - 1
        let roomId = dependency.room.id
        let s = otherUsersCount > 1 ? "s" : ""
        let otherUsersText = "and \(String(otherUsersCount)) guy\(s)"
        
        let headerTitle = "\(currentUserName) \(otherUsersText) in Room: \(roomId)"
        
        dependency.viewModel.headerTitle = headerTitle
    }
    
    func subscribeUser() {
        dependency.dataStore.subscribeUser()
    }
    
    func didSelectCard(cardId: String) async {
        dependency.currentUser.selectedCardId = cardId
        await dependency.dataStore.addCardToSelectedCardList(userId: dependency.currentUser.id,
                                                             cardId: cardId)
    }
    
    func openSelectedCardList() {
        dependency.viewModel.isOpenSelectedCardList = true
        
    }
    
    func resetSelectedCardList() {
        dependency.viewModel.isOpenSelectedCardList = false
        
    }
    
    func leaveRoom() async {
        await dependency.dataStore.removeUserFromRoom(userId: dependency.currentUser.id)
    }
    
    func unsubscribeUser() {
        dependency.dataStore.unsubscribeUser()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    /// 選択されたカード一覧
    private var selectedCardList: [Card] = []
}

// MARK: - RoomDelegate

extension CardListPresenter: RoomDelegate {
    func whenUserAdded() {
        outputHeaderTitle()
    }
    
    func whenUserModified() {
        // 選択されたカード一覧を更新する
        let room = dependency.room
        // TODO: 今のままだと、Firestoreのroomを取得できていないので、selectedCardListが他ユーザと共有されない
        selectedCardList = room.userList.map { user in
            room.cardPackage.cardList.first(where: { $0.id == user.selectedCardId! })!
        }
    }
    
    func whenUserRemoved() {
        outputHeaderTitle()
    }
}
