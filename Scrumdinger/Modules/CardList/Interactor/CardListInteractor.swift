import Foundation

class CardListInteractor: CardListUseCase {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var room: Room
        var currentUser: User
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListUseCase
    
    func subscribeUser() {
        dependency.dataStore.subscribeUser()
    }
    
    func unsubscribeUser() {
        dependency.dataStore.unsubscribeUser()
    }
    
    func updateSelectedCardId() {
        dependency.dataStore.updateSelectedCardId(selectedCardDictionary: [dependency.currentUser.id: card.id])
    }
    
    func fetchRoom() {
        Task {
            dependency.room = await dependency.dataStore.fetchRoom()
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}
