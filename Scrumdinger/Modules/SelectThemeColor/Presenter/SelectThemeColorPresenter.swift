import Foundation

final class SelectThemeColorPresenter: SelectThemeColorPresentation, SelectThemeColorInteractorOutput, DependencyInjectable {
    
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var useCase: SelectThemeColorUseCase
        weak var viewModel: SelectThemeColorViewModel?
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Presentation
    
    func viewDidLoad() {
        showColorList()
    }
    
    func viewDidResume() {
        showColorList()
    }
    
    func viewDidSuspend() {}
    
    // MARK: - SelectThemeColorPresentation
    
    func didTapColor(color: ThemeColor) {
        dependency.useCase.updateThemeColor(themeColor: color)
    }
    
    // MARK: - SelectThemeColorInteractorOutput
    
    func outputSelectedThemeColor(_ themeColor: ThemeColor) {
        Task { @MainActor in
            dependency.viewModel?.selectedThemeColor = themeColor
            disableButton(false)
            showLoader(false)
        }
    }
    
    func outputSuccess(message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = .init(type: .onSuccess, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
    
    func outputError(_ error: Error, message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = .init(type: .onFailure, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }

    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// カラー一覧を表示する
    private func showColorList() {
        Task { @MainActor in
            dependency.viewModel?.themeColorList = ThemeColor.allCases
        }
    }
    
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
}
