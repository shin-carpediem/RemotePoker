import Foundation

class SelectThemeColorPresenter: SelectThemeColorPresentation, SelectThemeColorPresentationOutput {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var viewModel: SelectThemeColorViewModel
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SelectThemeColorPresentation
    
    func didTapColor(themeColor: ThemeColor) {
        dependency.dataStore.updateThemeColor(themeColor: themeColor)
    }
    
    // MARK: - SelectThemeColorPresentationOutput
    
    func outputColorList() {
        dependency.viewModel.themeColorList = ThemeColor.allCases
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}
