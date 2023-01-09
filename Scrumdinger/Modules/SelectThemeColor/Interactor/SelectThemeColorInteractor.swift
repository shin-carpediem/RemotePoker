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
        let message = "Switched theme color to \(themeColor)"
        dependency.output?.outputSuccess(message: message)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
