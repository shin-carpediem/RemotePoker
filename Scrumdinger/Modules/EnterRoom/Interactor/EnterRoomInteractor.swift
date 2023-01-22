import Foundation

final class EnterRoomInteractor: EnterRoomUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var repository: UndefinedRoomRepository
        weak var output: EnterRoomInteractorOutput?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - EnterRoomUseCase

    func checkRoomExist(roomId: Int) async -> Bool {
        await dependency.repository.checkRoomExist(roomId: roomId)
    }

    func createRoom(room: Room) async {
        let result = await dependency.repository.createRoom(room)
        switch result {
        case .success(_):
            let message = "新しいルームを作りました"
            await dependency.output?.outputSuccess(message: message)

        case .failure(let error):
            let message = "新しいルームを作れませんでした"
            await dependency.output?.outputError(error, message: message)
        }
    }

    func adduserToRoom(roomId: Int, user: User) async {
        repository = RoomDataStore(roomId: roomId)
        guard let repository = repository else { return }
        let result = await repository.addUserToRoom(user: user)
        switch result {
        case .success(_):
            let message = "ルームに追加されました"
            await dependency.output?.outputSuccess(message: message)

        case .failure(let error):
            let message = "ルームに追加できませんでした"
            await dependency.output?.outputError(error, message: message)
        }
    }

    // MARK: - Private

    private var dependency: Dependency!

    private var repository: RoomRepository?
}
