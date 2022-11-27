class CardListPresenter: CardListPresentation {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var room: Room
        var currentUser: User
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListPresentation
    
    func subscribeUser() {
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
