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
        userListCancellable = dependency.roomRepository.userList.sink { userList in
            Task { [weak self] in
                await self?.dependency.output?.outputUserList(userList)
            }
        }
    }

    func subscribeCardPackages() {
        cardPackageCancellable = dependency.roomRepository.cardPackage.sink { cardPackage in
            Task { [weak self] in
                await self?.dependency.output?.outputCardPackage(cardPackage)
            }
        }
    }

    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        dependency.roomRepository.updateSelectedCardId(
            selectedCardDictionary: selectedCardDictionary)
    }

    func requestUser(userId: String) {
        dependency.roomRepository.fetchUser(id: userId) { result in
            Task { [weak self] in
                switch result {
                case .success(let user):
                    await self?.dependency.output?.outputCurrentUser(user)

                case .failure(let error):
                    let message = "ユーザーを見つけられませんでした"
                    await self?.dependency.output?.outputError(error, message: message)
                }
            }
        }
    }

    // MARK: - Private

    private var dependency: Dependency!

    private var userListCancellable: AnyCancellable?

    private var cardPackageCancellable: AnyCancellable?
}
