import Combine
import Model
import Protocols
import RemotePokerData

public final class EnterRoomInteractor: DependencyInjectable {
    public init() {}

    // MARK: DependencyInjectable

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

    private var dependency: Dependency!
    private var cancellables = Set<AnyCancellable>()
}

// MARK: EnterRoomUseCase

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
    
    public func createUser(_ user: UserModel) async {
        let entity = UserEntity(id: user.id,
                                name: user.name,
                                selectedCardId: user.selectedCardId)
        switch await dependency.repository.createUser(entity) {
        case .success:
            dependency.output?.outputSuccess(message: "ユーザー登録しました")
            
        case .failure(let error):
            dependency.output?.outputError(error, message: "ユーザー登録できませんでした")
        }
    }

    public func checkRoomExist(by roomId: Int) async -> Bool {
        await dependency.repository.checkRoomExist(roomId: String(roomId))
    }

    public func createRoom(_ room: RoomModel) async {
        let entity = RoomEntity(
            id: room.id,
            userIdList: room.userIdList,
            cardPackage: CardPackageEntity(
                id: room.cardPackage.id,
                themeColor: room.cardPackage.themeColor,
                cardList: room.cardPackage.cardList.map {
                    CardPackageEntity.Card(id: $0.id, estimatePoint: $0.estimatePoint, index: $0.index)
                }))
        switch await dependency.repository.createRoom(entity) {
        case .success:
            dependency.output?.outputSuccess(message: "新しいルームを作りました")

        case .failure(let error):
            dependency.output?.outputError(error, message: "新しいルームを作れませんでした")
        }
    }

    public func adduserToRoom(roomId: Int, userId: String) async {
        switch await CurrentRoomDataStore(userId: userId, roomId: String(roomId)).addUserToRoom() {
        case .success:
            dependency.output?.outputSuccess(message: "ルームに追加されました")

        case .failure(let error):
            dependency.output?.outputError(error, message: "ルームに追加できませんでした")
        }
    }
}
