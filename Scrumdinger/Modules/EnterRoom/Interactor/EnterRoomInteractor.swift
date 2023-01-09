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
            let message = "Failed to find the room."
            dependency.output?.outputError(error, message: message)
        }
    }
    
    func adduserToRoom(user: User) async {
        let result = await dependency.roomRepository.addUserToRoom(user: user)
        switch result {
        case .success(_):
            let message = "Added you to the room."
            dependency.output?.outputSuccess(message: message)
            
        case .failure(let error):
            let message = "Failed to add you to the room."
            dependency.output?.outputError(error, message: message)
        }
    }
    
    func createRoom(room: Room) async {
        let result = await dependency.roomRepository.createRoom(room)
        switch result {
        case .success(_):
            let message = "Created a new room."
            dependency.output?.outputSuccess(message: message)
            
        case .failure(let error):
            let message = "Failed to create a new room."
            dependency.output?.outputError(error, message: message)
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
