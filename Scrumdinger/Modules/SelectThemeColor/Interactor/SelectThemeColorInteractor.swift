import Foundation

final class SelectThemeColorInteractor: SelectThemeColorUseCase, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var roomRepository: RoomRepository
        weak var output: SelectThemeColorInteractorOutput?
        var cardPackageId: String
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - CardListUseCase

    func updateThemeColor(themeColor: ThemeColor) {
        Task { @MainActor in
            dependency.roomRepository.updateThemeColor(
                cardPackageId: dependency.cardPackageId,
                themeColor: themeColor)

            dependency.output?.outputSelectedThemeColor(themeColor)
            let message = "テーマカラーを\(themeColor)に変更しました"
            dependency.output?.outputSuccess(message: message)
        }
    }

    // MARK: - Private

    private var dependency: Dependency!
}
