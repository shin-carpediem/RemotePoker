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
    
    // MARK: - SelectThemeColorPresentation
    
    func didTapColor(color: ThemeColor) {
        dependency.useCase.updateThemeColor(themeColor: color)
    }
    
    // MARK: - Presentation
    
    func viewDidLoad() {
//        dependency.useCase.updateThemeColor(themeColor: dependency.room.cardPackage.themeColor)
        showColorList()
    }
    
    func viewDidResume() {}
    
    func viewDidSuspend() {}
    
    // MARK: - SelectThemeColorInteractorOutput
    
    func outputSelectedThemeColor(_ themeColor: ThemeColor) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.viewModel?.selectedThemeColor = themeColor
        }
    }
    
    func outputSuccess() {
        
    }
    
    func outputError(_ error: Error) {
        
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
