import Combine
import Model
import Protocols
import RemotePokerData

public final class CardListInteractor: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var enterRoomRepository: EnterRoomRepository
        public var roomRepository: RoomRepository
        public weak var output: CardListInteractorOutput?

        public init(
            enterRoomRepository: EnterRoomRepository, roomRepository: RoomRepository,
            output: CardListInteractorOutput?
        ) {
            self.enterRoomRepository = enterRoomRepository
            self.roomRepository = roomRepository
            self.output = output
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Private

    private var dependency: Dependency!
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - CardListUseCase

extension CardListInteractor: CardListUseCase {
    public func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.enterRoomRepository.checkRoomExist(roomId: String(roomId))
    }

    public func subscribeCurrentRoom() {
        dependency.roomRepository.room
            .combineLatest(dependency.roomRepository.userList)
            .sink { [weak self] roomEntity, userListEntity in
                let cardPackage: CardPackageEntity = roomEntity.cardPackage
                let cardList: [CardPackageModel.Card] = cardPackage.cardList.map { CardPackageModel.Card(id: $0.id, estimatePoint: $0.estimatePoint, index: $0.index) }
                let userList: [UserModel] = userListEntity.map {
                    UserModel(id: $0.id, name: $0.name, selectedCardId: $0.selectedCardId)
                }
                let model = CurrentRoomModel(id: roomEntity.id, userList: userList, cardPackage: .init(id: cardPackage.id, themeColor: cardPackage.themeColor, cardList: cardList))

                self?.dependency.output?.outputRoom(model)
            }
            .store(in: &cancellables)
    }

    public func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        dependency.roomRepository.updateSelectedCardId(
            selectedCardDictionary: selectedCardDictionary)
    }

    public func requestUser() async {
        dependency.roomRepository.fetchUser()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.dependency.output?.outputError(error, message: "ユーザーを取得できませんでした")
                    
                case .finished:
                    ()
                }
            }, receiveValue: { [weak self] in
                let model = UserModel(
                    id: $0.id, name: $0.name,
                    selectedCardId: $0.selectedCardId)
                self?.dependency.output?.outputCurrentUser(model)
            })
            .store(in: &cancellables)
    }
}
