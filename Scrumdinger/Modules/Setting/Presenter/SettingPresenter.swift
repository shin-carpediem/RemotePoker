import Foundation

final class SettingPresenter: SettingPresentation, SettingInteractorOutput, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var useCase: SettingUseCase
        weak var viewModel: SettingViewModel?
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SettingPresentation
    
    func didTapSelectThemeColorButton() {
        disableButton(true)
        pushSelectThemeColorView()
    }
    
    func didTapLeaveRoomButton() {
        Task {
            disableButton(true)
            LocalStorage.shared.currentRoomId = 0
            dependency.useCase.unsubscribeUser()
            await dependency.useCase.leaveRoom()
        }
    }
    
    // MARK: - Presentation
    
    func viewDidLoad() {}
    
    func viewDidResume() {}
    
    func viewDidSuspend() {}
    
    // MARK: - SettingInteractorOutput
    
    func outputSuccess() {
        
    }
    
    func outputError(_ errror: Error) {
        
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isButtonEnabled = !disabled
        }
    }
    
    // MARK: - Router
    
    /// テーマカラー選択画面に遷移する
    private func pushSelectThemeColorView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.willPushSelectThemeColorView = true
        }
    }
}
