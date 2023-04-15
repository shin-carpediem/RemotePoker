import Combine
import RemotePokerData

final class EnterRoomInteractor: EnterRoomUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var repository: EnterRoomRepository
        weak var output: EnterRoomInteractorOutput?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - EnterRoomUseCase

    func signIn(userName: String, roomId: Int) async {
        AuthDataStore.shared.signIn()
            .sink { [weak self] userId in
                self?.dependency.output?.outputCompletedSignIn(
                    userId: userId, userName: userName, roomId: roomId)
            }
            .store(in: &self.cancellablesForAction)
    }

    func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.repository.checkRoomExist(roomId: roomId)
    }

    func createRoom(room: RoomModel) async {
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

    func adduserToRoom(roomId: Int, user: UserModel) async {
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

    // MARK: - Private

    private var dependency: Dependency!

    private var repository: RoomRepository?

    private var cancellablesForAction = Set<AnyCancellable>()
}
