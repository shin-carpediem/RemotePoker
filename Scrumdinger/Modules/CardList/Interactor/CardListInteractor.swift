import Combine
import Foundation

final class CardListInteractor: CardListUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var enterRoomRepository: EnterRoomRepository
        var roomRepository: RoomRepository
        weak var output: CardListInteractorOutput?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - CardListUseCase

    func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.enterRoomRepository.checkRoomExist(roomId: roomId)
    }

    func subscribeUsers() {
        dependency.roomRepository.userList
            .sink { userList in
                Task { [unowned self] in
                    await self.dependency.output?.outputUserList(userList)
                }
            }
            .store(in: &self.cancellablesForSubscription)
    }

    func subscribeCardPackages() {
        dependency.roomRepository.cardPackage
            .sink { cardPackage in
                Task { [unowned self] in
                    await self.dependency.output?.outputCardPackage(cardPackage)
                }
            }
            .store(in: &self.cancellablesForSubscription)
    }

    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        dependency.roomRepository.updateSelectedCardId(
            selectedCardDictionary: selectedCardDictionary)
    }

    func requestUser(userId: String) async {
        dependency.roomRepository.fetchUser(byId: userId)
            .sink { user in
                Task { [unowned self] in
                    await self.dependency.output?.outputCurrentUser(user)
                }
            }
            .store(in: &self.cancellablesForAction)
    }

    // MARK: - Private

    private var dependency: Dependency!

    private var cancellablesForSubscription = Set<AnyCancellable>()

    private var cancellablesForAction = Set<AnyCancellable>()
}
