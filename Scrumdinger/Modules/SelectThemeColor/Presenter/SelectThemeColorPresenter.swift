import Foundation

final class SelectThemeColorPresenter: SelectThemeColorPresentation, SelectThemeColorInteractorOutput, DependencyInjectable {
    
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var useCase: SelectThemeColorUseCase
        var room: Room
        weak var viewModel: SelectThemeColorViewModel?
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Presentation
    
    func viewDidLoad() {
        showColorList()
    }
    
    func viewDidResume() {}
    
    func viewDidSuspend() {}
    
    // MARK: - SelectThemeColorPresentation
    
    func didTapColor(color: ThemeColor) {
        dependency.useCase.updateThemeColor(themeColor: color)
    }
    
    // MARK: - SelectThemeColorInteractorOutput
    
    func outputSelectedThemeColor(_ themeColor: ThemeColor) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.selectedThemeColor = themeColor
        }
    }
    
    func outputSuccess(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownBanner = true
            self?.dependency.viewModel?.bannerMessgage = .init(type: .onSuccess, text: message)
        }
    }
    
    func outputError(_ error: Error, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.isShownBanner = true
            self?.dependency.viewModel?.bannerMessgage = .init(type: .onFailure, text: message)
        }
    }

    // MARK: - Private
    
    private var dependency: Dependency!
    
    /// カラー一覧を表示する
    private func showColorList() {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.themeColorList = ThemeColor.allCases
        }
    }
}
