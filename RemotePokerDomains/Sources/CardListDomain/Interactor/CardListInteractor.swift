import Combine
import Model
import Protocols
import RemotePokerData

public final class CardListInteractor: DependencyInjectable {
    public init() {}

    // MARK: DependencyInjectable

    public struct Dependency {
        public var enterRoomRepository: EnterRoomRepository
        public var currentRoomRepository: CurrentRoomRepository
        public weak var output: CardListInteractorOutput?

        public init(
            enterRoomRepository: EnterRoomRepository, currentRoomRepository: CurrentRoomRepository,
            output: CardListInteractorOutput?
        ) {
            self.enterRoomRepository = enterRoomRepository
            self.currentRoomRepository = currentRoomRepository
            self.output = output
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    private var dependency: Dependency!
    private var cancellables = Set<AnyCancellable>()
}

// MARK: CardListUseCase

extension CardListInteractor: CardListUseCase {
    public func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.enterRoomRepository.checkRoomExist(roomId: String(roomId))
    }

    public func subscribeCurrentRoom() {
        dependency.currentRoomRepository.room
            .combineLatest(dependency.currentRoomRepository.userList)
            .sink { [weak self] roomEntity, userEntityList in
                self?.dependency.output?.outputRoom(.init(id: roomEntity.id,
                                                          userList: userEntityList.map { UserModel(id: $0.id, name: $0.name, selectedCardId: $0.selectedCardId) },
                                                          cardPackage: .init(id: roomEntity.cardPackage.id, themeColor: roomEntity.cardPackage.themeColor, cardList: roomEntity.cardPackage.cardList.map { CardPackageModel.Card(id: $0.id, estimatePoint: $0.estimatePoint, index: $0.index) })))
            }
            .store(in: &cancellables)
    }

    public func updateSelectedCardId(selectedCardDictionary: [String: Int]) {
        dependency.currentRoomRepository.updateSelectedCardId(
            selectedCardDictionary: selectedCardDictionary)
    }

    public func requestUser() async {
        dependency.currentRoomRepository.fetchUser()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.dependency.output?.outputError(error, message: "ユーザーを取得できませんでした")
                    
                case .finished:
                    ()
                }
            }, receiveValue: { [weak self] in
                self?.dependency.output?.outputCurrentUser(.init(id: $0.id, name: $0.name, selectedCardId: $0.selectedCardId))
            })
            .store(in: &cancellables)
    }
}
