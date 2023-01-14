import Foundation

final class CardListInteractor: CardListUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var roomRepository: RoomDataStore
        weak var output: CardListInteractorOutput?
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
        dependency.roomRepository.updateSelectedCardId(
            selectedCardDictionary: selectedCardDictionary)
    }

    func requestRoom() async {
        let result = await dependency.roomRepository.fetchRoom()
        switch result {
        case .success(let room):
            await dependency.output?.outputRoom(room)

        case .failure(let error):
            let message = "Failed to find room."
            await dependency.output?.outputError(error, message: message)
        }
    }

    // MARK: - Private

    private var dependency: Dependency!
}
