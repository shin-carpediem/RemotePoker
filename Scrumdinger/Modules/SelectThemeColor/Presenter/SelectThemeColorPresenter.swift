import Foundation

class SelectThemeColorPresenter: SelectThemeColorPresentation {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - SelectThemeColorPresentation
    
    func didTapColor() {
        
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}
