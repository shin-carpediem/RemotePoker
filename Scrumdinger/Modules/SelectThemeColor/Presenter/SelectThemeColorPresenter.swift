import Foundation

class SelectThemeColorPresenter: SelectThemeColorPresentation {
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

    // MARK: - Private
    
    private var dependency: Dependency
    
    /// カラー一覧を表示する
    private func showColorList() {
        dependency.viewModel.themeColorList = ThemeColor.allCases
    }
}
