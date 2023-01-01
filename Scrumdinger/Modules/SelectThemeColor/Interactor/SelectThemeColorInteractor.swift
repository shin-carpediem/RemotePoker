import Foundation

class SelectThemeColorInteractor: SelectThemeColorUseCase {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
        var presenter: SelectThemeColorPresenter?
        var room: Room
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var dependency: Dependency
    
    // MARK: - CardListUseCase
    
    func updateThemeColor(themeColor: ThemeColor) {
        dependency.dataStore.updateThemeColor(cardPackageId: dependency.room.cardPackage.id,
                                              themeColor: themeColor)
    }
}
