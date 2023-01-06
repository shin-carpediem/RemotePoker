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
        let result = await dependency.roomRepository.fetchRoom()
        switch result {
        case .success(let room):
            dependency.output?.outputRoom(room)
        
        case .failure(let error):
            dependency.output?.outputError(error)
        }
    }
    
    func adduserToRoom(user: User) async {
        let result = await dependency.roomRepository.addUserToRoom(user: user)
        switch result {
        case .success(_):
            dependency.output?.outputSuccess()
            
        case .failure(let error):
            dependency.output?.outputError(error)
        }
    }
    
    func createRoom(room: Room) async {
        let result = await dependency.roomRepository.createRoom(room)
        switch result {
        case .success(_):
            dependency.output?.outputSuccess()
            
        case .failure(let error):
            dependency.output?.outputError(error)
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
