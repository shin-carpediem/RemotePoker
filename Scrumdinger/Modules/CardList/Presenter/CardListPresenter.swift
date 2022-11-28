class CardListPresenter: CardListPresentation {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var room: Room
        var currentUser: User
    }
    
    var view: CardListView?
        
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListPresentation
    
    func outputHeaderTitle() {
        let currentUserName = dependency.currentUser.name
        let otherUsersCount = dependency.room.userList.count - 1
        let roomId = dependency.room.id
        let s = otherUsersCount > 1 ? "s" : ""
        
        let headerTitle = "\(currentUserName) & \(String(otherUsersCount)) member\(s) in Room ID: \(roomId)"
        
        view?.headerTitle = headerTitle
    }
    
    func subscribeUser() {
        dependency.dataStore.subscribeUser()
    }
    
    func openSelectedCardList() {
    }
    
    func resetSelectedCardList() {
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
        outputHeaderTitle()
    }
    
    func whenUserModified() {}
    
    func whenUserRemoved() {
        outputHeaderTitle()
    }
}
