import Foundation

final class SelectThemeColorInteractor: SelectThemeColorUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable
    
    struct Dependency {
        var roomRepository: RoomRepository
        weak var output: SelectThemeColorInteractorOutput?
        var room: Room
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - CardListUseCase
    
    func updateThemeColor(themeColor: ThemeColor) {
        dependency.roomRepository.updateThemeColor(cardPackageId: dependency.room.cardPackage.id,
                                                   themeColor: themeColor)

        dependency.output?.outputSelectedThemeColor(themeColor)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
