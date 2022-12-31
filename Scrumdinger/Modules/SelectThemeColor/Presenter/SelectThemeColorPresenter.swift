import Foundation

class SelectThemeColorPresenter: SelectThemeColorPresentation, SelectThemeColorPresentationOutput {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var room: Room
        var viewModel: SelectThemeColorViewModel
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SelectThemeColorPresentation
    
    func viewDidLoad() {
        outputColorList()
    }
    
    func didTapColor(themeColor: ThemeColor) {
        dependency.dataStore.updateThemeColor(cardPackageId: dependency.room.cardPackage.id,
                                              themeColor: themeColor)
    }
    
    // MARK: - SelectThemeColorPresentationOutput
    
    func outputColorList() {
        dependency.viewModel.themeColorList = ThemeColor.allCases
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}
