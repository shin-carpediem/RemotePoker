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

    private var cancellablesForAction = Set<AnyCancellable>()
}

// MARK: - EnterRoomUseCase

extension EnterRoomInteractor: EnterRoomUseCase {
    public func signIn(userName: String, roomId: Int) async {
        AuthDataStore.shared.signIn()
            .sink { [weak self] userId in
                self?.dependency.output?.outputCompletedSignIn(
                    userId: userId, userName: userName, roomId: roomId)
            }
            .store(in: &cancellablesForAction)
    }

    public func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.repository.checkRoomExist(roomId: roomId)
    }

    public func createRoom(room: RoomModel) async {
        let entity = RoomEntity(
            id: room.id,
            userList: room.userList.map {
                UserEntity(
                    id: $0.id, name: $0.name, currentRoomId: $0.currentRoomId,
                    selectedCardId: $0.selectedCardId)
            },
            cardPackage: CardPackageEntity(
                id: room.cardPackage.id,
                themeColor: room.cardPackage.themeColor,
                cardList: room.cardPackage.cardList.map {
                    CardPackageEntity.Card(id: $0.id, point: $0.point, index: $0.index)
                }))
        let result: Result<Void, FirebaseError> = await dependency.repository.createRoom(entity)
        switch result {
        case .success(_):
            await dependency.output?.outputSuccess(message: "新しいルームを作りました")

        case .failure(let error):
            await dependency.output?.outputError(error, message: "新しいルームを作れませんでした")
        }
    }

    public func adduserToRoom(roomId: Int, user: UserModel) async {
        repository = RoomDataStore(roomId: roomId)
        guard let repository = repository else { return }
        let entity = UserEntity(
            id: user.id,
            name: user.name,
            currentRoomId: user.currentRoomId,
            selectedCardId: user.selectedCardId)
        let result: Result<Void, FirebaseError> = await repository.addUserToRoom(user: entity)
        switch result {
        case .success(_):
            await dependency.output?.outputSuccess(message: "ルームに追加されました")

        case .failure(let error):
            await dependency.output?.outputError(error, message: "ルームに追加できませんでした")
        }
    }
}
