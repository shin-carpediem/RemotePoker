import Foundation

class SettingPresenter: SettingPresentation {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var currentUser: User
        var viewModel: SettingViewModel
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SettingPresentation
    
    func didTapLeaveRoomButton() {
        disableButton(true)
        AppConfig.shared.resetLocalLogInData()
        dependency.dataStore.unsubscribeUser()
        Task {
            await dependency.dataStore.removeUserFromRoom(userId: dependency.currentUser.id)
        }
        
        // TODO: ログイン画面に遷移
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonEnabled = !disabled
        }
    }
}
