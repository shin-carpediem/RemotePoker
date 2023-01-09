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
        pushSelectThemeColorView()
    }
    
    func didTapLeaveRoomButton() {
        Task {
            disableButton(true)
            showLoader(true)
            LocalStorage.shared.currentRoomId = 0
            await dependency.useCase.leaveRoom()
            dependency.useCase.unsubscribeUser()
            dependency.useCase.unsubscribeCardPackages()
            dependency.useCase.disposeRoomRepository()
            disableButton(false)
            showLoader(false)
        }
    }
    
    // MARK: - SettingInteractorOutput
    
    func outputSuccess(message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = .init(type: .onSuccess, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
    
    func outputError(_ errror: Error, message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = .init(type: .onFailure, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// ボタンを無効にする
    private func disableButton(_ disabled: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isButtonEnabled = !disabled
        }
    }
    
    /// ローダーを表示する
    private func showLoader(_ show: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isShownLoader = show
        }
    }
    
    // MARK: - Router
    
    /// テーマカラー選択画面に遷移する
    private func pushSelectThemeColorView() {
        Task { @MainActor in
            dependency.viewModel?.willPushSelectThemeColorView = true
            disableButton(false)
            showLoader(false)
        }
    }
}
