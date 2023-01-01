import Foundation

class SettingPresenter: SettingPresentation, SettingPresentationOutput {
    // MARK: - Dependency
    
    struct Dependency {
        var interactor: SettingInteractor
        var viewModel: SettingViewModel
    }
    
    init(dependency: Dependency) {
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
            AppConfig.shared.resetLocalLogInData()
            dependency.interactor.unsubscribeUser()
            await dependency.interactor.leaveRoom()
        }
    }
    
    // MARK: - SettingPresentationOutput
    
    func outputSuccess() {
        
    }
    
    func outputError() {
        
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.isButtonEnabled = !disabled
        }
    }
    
    // MARK: - Router
    
    /// テーマカラー選択画面に遷移する
    private func pushSelectThemeColorView() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel.willPushSelectThemeColorView = true
        }
    }
}
