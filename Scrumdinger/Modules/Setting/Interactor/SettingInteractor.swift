import Foundation

class SettingInteractor: SettingUseCase {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var presenter: SettingPresenter?
        var currentUser: User
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var dependency: Dependency
    
    // MARK: - SettingUseCase
    
    func leaveRoom() async {
        await dependency.dataStore.removeUserFromRoom(userId: dependency.currentUser.id)
    }
    
    func unsubscribeUser() {
        dependency.dataStore.unsubscribeUser()
    }
}
