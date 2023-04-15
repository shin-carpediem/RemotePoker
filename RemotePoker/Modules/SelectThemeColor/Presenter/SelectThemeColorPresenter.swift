import Foundation
import RemotePokerViews

final class SelectThemeColorPresenter: SelectThemeColorPresentation, DependencyInjectable {

    // MARK: - DependencyInjectable

    struct Dependency {
        var repository: RoomRepository
        weak var viewModel: SelectThemeColorViewModel?
        var cardPackageId: String
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - SelectThemeColorPresentation

    func didTapColor(color: CardPackageThemeColor) {
        Task { @MainActor in
            dependency.repository.updateThemeColor(
                cardPackageId: dependency.cardPackageId,
                themeColor: color.rawValue)

            applySelectedThemeColor(color)
            showSuccess(message: "テーマカラーを\(color)に変更しました")
        }
    }

    // MARK: - Presentation

    func viewDidLoad() {
        Task {
            await showColorList()
        }
    }

    func viewDidResume() {
        Task {
            await showColorList()
        }
    }

    func viewDidSuspend() {}

    // MARK: - Private

    private var dependency: Dependency!

    /// カラー一覧を表示する
    @MainActor
    private func showColorList() {
        dependency.viewModel?.themeColorList = CardPackageThemeColor.allCases
    }

    /// 選択されたテーマカラーで表示する
    @MainActor
    private func applySelectedThemeColor(_ themeColor: CardPackageThemeColor) {
        dependency.viewModel?.selectedThemeColor = themeColor
    }

    /// 成功を表示する
    @MainActor
    private func showSuccess(message: String) {
        dependency.viewModel?.bannerMessgage = NotificationMessage(type: .onSuccess, text: message)
        dependency.viewModel?.isShownBanner = true
    }
}
