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
    
    // MARK: - Presentation
    
    func viewDidLoad() {}
    
    func viewDidResume() {}
    
    func viewDidSuspend() {}
    
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
    
    // MARK: - SettingInteractorOutput
    
    func outputSuccess(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownBanner = true
            self?.dependency.viewModel?.bannerMessgage = .init(type: .onSuccess, text: message)
        }
    }
    
    func outputError(_ errror: Error, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownBanner = true
            self?.dependency.viewModel?.bannerMessgage = .init(type: .onFailure, text: message)
        }
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
