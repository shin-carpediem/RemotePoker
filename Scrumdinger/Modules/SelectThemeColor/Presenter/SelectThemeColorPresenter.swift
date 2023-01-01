import Foundation

class SelectThemeColorPresenter: SelectThemeColorPresentation, SelectThemeColorPresentationOutput {
    // MARK: - Dependency
    
    struct Dependency {
        var interactor: SelectThemeColorInteractor
        var room: Room
        var viewModel: SelectThemeColorViewModel
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SelectThemeColorPresentation
    
    func viewDidLoad() {
        showColorList()
    }
    
    func didTapColor(color: ThemeColor) {
        dependency.interactor.updateThemeColor(themeColor: color)
    }
    
    // MARK: - SelectThemeColorPresentationOutput
    
    func outputSuccess() {
        
    }
    
    func outputError() {
        
    }

    // MARK: - Private
    
    private var dependency: Dependency
    
    /// カラー一覧を表示する
    private func showColorList() {
        dependency.viewModel.themeColorList = ThemeColor.allCases
    }
}
