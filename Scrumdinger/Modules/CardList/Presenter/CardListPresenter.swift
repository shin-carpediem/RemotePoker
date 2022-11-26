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
    
    func subscribeRoom() {
        // TODO: ovservable
    }
    
    func openSelectedCardList() {
    }
    
    func resetSelectedCardList() {
    }
    
    func leaveRoom() async {
        await dependency.dataStore.removeUserFromRoom(userId: dependency.currentUser.id)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}
