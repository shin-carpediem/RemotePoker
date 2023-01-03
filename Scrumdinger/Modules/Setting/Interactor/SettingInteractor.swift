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
        await dependency.roomRepository.removeUserFromRoom(userId: dependency.currentUser.id)
        let result = RoomAuthDataStore.shared.logout()
        switch result {
        case .success(_):
            dependency.output?.outputSuccess()
            
        case .failure(let error):
            dependency.output?.outputError(error)
        }
    }
    
    func unsubscribeUser() {
        dependency.roomRepository.unsubscribeUser()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
