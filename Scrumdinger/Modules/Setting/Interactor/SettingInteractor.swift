import Foundation

final class SettingInteractor: SettingUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var roomRepository: RoomRepository
        weak var output: SettingInteractorOutput?
        var currentUser: User
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SettingUseCase
    
    func leaveRoom() async {
        let result = await dependency.roomRepository.removeUserFromRoom(userId: dependency.currentUser.id)
        switch result {
        case .success(_):
            let logoutResult = RoomAuthDataStore.shared.logout()
            switch logoutResult {
            case .success(_):
                dependency.output?.outputSuccess(message: "Left the room.")
                
            case .failure(let error):
                dependency.output?.outputError(error, message: "Failed to leave the room.")
            }
            
        case .failure(let error):
            dependency.output?.outputError(error, message: "Failed to leave the room.")
        }
    }
    
    func unsubscribeUser() {
        dependency.roomRepository.unsubscribeUser()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}