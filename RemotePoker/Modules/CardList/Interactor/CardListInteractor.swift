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
                    let model: [UserModel] = userList.map {
                        UserModel(
                            id: $0.id, name: $0.name, currentRoomId: $0.currentRoomId,
                            selectedCardId: $0.selectedCardId)
                    }
                    await self.dependency.output?.outputUserList(model)
                }
            }
            .store(in: &self.cancellablesForSubscription)
    }

    func subscribeCardPackages() {
        dependency.roomRepository.cardPackage
            .sink { cardPackage in
                Task { [unowned self] in
                    let model = CardPackageModel(
                        id: cardPackage.id, themeColor: cardPackage.themeColor,
                        cardList: cardPackage.cardList.map {
                            CardPackageModel.Card(id: $0.id, point: $0.point, index: $0.index)
                        })
                    await self.dependency.output?.outputCardPackage(model)
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
                    let model = UserModel(
                        id: user.id, name: user.name, currentRoomId: user.currentRoomId,
                        selectedCardId: user.selectedCardId)
                    await self.dependency.output?.outputCurrentUser(model)
                }
            }
            .store(in: &self.cancellablesForAction)
    }

    // MARK: - Private

    private var dependency: Dependency!

    private var cancellablesForSubscription = Set<AnyCancellable>()

    private var cancellablesForAction = Set<AnyCancellable>()
}