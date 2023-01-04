import Foundation

final class CardListInteractor: CardListUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var roomRepository: RoomDataStore
        weak var output: CardListInteractorOutput?
        var room: Room
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListUseCase
    
    func activateRoomDelegate(_ self: CardListPresenter) {
        dependency.roomRepository.delegate = self
    }
    
    func subscribeUsers() {
        dependency.roomRepository.subscribeUser()
    }
    
    func unsubscribeUsers() {
        dependency.roomRepository.unsubscribeUser()
    }
    
    func subscribeCardPackages() {
        dependency.roomRepository.subscribeCardPackage()
    }
    
    func unsubscribeCardPackages() {
        dependency.roomRepository.unsubscribeCardPackage()
    }
    
    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        dependency.roomRepository.updateSelectedCardId(selectedCardDictionary: selectedCardDictionary)
    }
    
    func requestRoom() async {
        let task = Task { () -> Room in
            await dependency.roomRepository.fetchRoom()
        }
        let result = await task.result
        do {
            let room = try result.get()
            dependency.output?.outputRoom(room)
        } catch {
            dependency.output?.outputError(.failedToRequestRoom)
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
