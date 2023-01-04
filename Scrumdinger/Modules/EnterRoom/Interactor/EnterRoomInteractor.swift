import Foundation

final class EnterRoomInteractor: EnterRoomUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var roomRepository: RoomDataStore
        weak var output: EnterRoomInteractorOutput?
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - EnterRoomUseCase
    
    func setupRoomRepository(roomId: Int) {
        dependency.roomRepository = RoomDataStore(roomId: roomId)
    }
    
    func checkUserInCurrentRoom(roomId: Int) async {
        let isUserInCurrentRoom = await dependency.roomRepository.checkRoomExist(roomId: roomId)
        dependency.output?.outputIsUserInCurrentRoom(isUserInCurrentRoom)
    }
    
    func requestUser(userId: String) {
        dependency.roomRepository.fetchUser(id: userId) { [weak self] user in
            self?.dependency.output?.outputUser(user)
        }
    }
    
    func requestRoom(roomId: Int) async {
        let room = await dependency.roomRepository.fetchRoom()
        dependency.output?.outputRoom(room)
    }
    
    func adduserToRoom(user: User) async {
        await dependency.roomRepository.addUserToRoom(user: user)
    }
    
    func createRoom(room: Room) async {
        await dependency.roomRepository.createRoom(room)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
