import Foundation

final class SettingInteractor: SettingUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var roomRepository: RoomRepository
        weak var output: SettingInteractorOutput?
        var currentUserId: String
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SettingUseCase
    
    func leaveRoom() async {
        let result = await dependency.roomRepository.removeUserFromRoom(userId: dependency.currentUserId)
        switch result {
        case .success(_):
            let logoutResult = RoomAuthDataStore.shared.logout()
            switch logoutResult {
            case .success(_):
                let message = "Left the room."
                dependency.output?.outputSuccess(message: message)
                
            case .failure(let error):
                let message = "Failed to leave the room."
                dependency.output?.outputError(error, message: message)
            }
            
        case .failure(let error):
            let message = "Failed to leave the room."
            dependency.output?.outputError(error, message: message)
        }
    }
    
    func disposeRoomRepository() {
        dependency.roomRepository = RoomDataStore()
    }
    
    func unsubscribeUser() {
        dependency.roomRepository.unsubscribeUser()
    }
    
    func unsubscribeCardPackages() {
        dependency.roomRepository.unsubscribeCardPackage()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
