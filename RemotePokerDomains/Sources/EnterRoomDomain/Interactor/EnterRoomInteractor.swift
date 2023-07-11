import Combine
import Model
import Protocols
import RemotePokerData

public final class EnterRoomInteractor: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var repository: EnterRoomRepository
        public weak var output: EnterRoomInteractorOutput?

        public init(repository: EnterRoomRepository, output: EnterRoomInteractorOutput?) {
            self.repository = repository
            self.output = output
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Private

    private var dependency: Dependency!
    private var repository: RoomRepository?
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - EnterRoomUseCase

extension EnterRoomInteractor: EnterRoomUseCase {
    public func signIn(userName: String, roomId: Int) async {
        AuthDataStore.shared.signIn()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.dependency.output?.outputError(error, message: "サインインできませんでした")
                    
                case .finished:
                    ()
                }
            }, receiveValue: { [weak self] userId in
                self?.dependency.output?.outputSucceedToSignIn(
                    userId: userId, userName: userName, roomId: roomId)
            })
            .store(in: &cancellables)
    }

    public func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.repository.checkRoomExist(roomId: String(roomId))
    }

    public func createRoom(room: RoomModel) async {
        let entity = RoomEntity(
            id: room.id,
            userIdList: room.userIdList,
            cardPackage: CardPackageEntity(
                id: room.cardPackage.id,
                themeColor: room.cardPackage.themeColor,
                cardList: room.cardPackage.cardList.map {
                    CardPackageEntity.Card(id: $0.id, estimatePoint: $0.estimatePoint, index: $0.index)
                }))
        let result: Result<Void, FirebaseError> = await dependency.repository.createRoom(entity)
        switch result {
        case .success:
            dependency.output?.outputSuccess(message: "新しいルームを作りました")

        case .failure(let error):
            dependency.output?.outputError(error, message: "新しいルームを作れませんでした")
        }
    }

    public func adduserToRoom(roomId: Int, userId: String) async {
        repository = RoomDataStore(userId: userId, roomId: String(roomId))
        guard let repository = repository else { return }
        let result: Result<Void, FirebaseError> = await repository.addUserToRoom()
        switch result {
        case .success:
            dependency.output?.outputSuccess(message: "ルームに追加されました")

        case .failure(let error):
            dependency.output?.outputError(error, message: "ルームに追加できませんでした")
        }
    }
}
