import Foundation
import Protocols
import RemotePokerData
import ViewModel

public final class SelectThemeColorPresenter: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var repository: RoomRepository
        public weak var viewModel: SelectThemeColorViewModel?
        public var cardPackageId: String

        public init(
            repository: RoomRepository, viewModel: SelectThemeColorViewModel?,
            cardPackageId: String
        ) {
            self.repository = repository
            self.viewModel = viewModel
            self.cardPackageId = cardPackageId
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Private

    private var dependency: Dependency!

    private func showColorList() {
        Task { @MainActor in
            dependency.viewModel?.themeColorList = CardPackageThemeColor.allCases
        }
    }

    private func applySelectedThemeColor(_ themeColor: CardPackageThemeColor) {
        Task { @MainActor in
            dependency.viewModel?.selectedThemeColor = themeColor
        }
    }

    private func showSuccess(message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onSuccess, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
}

// MARK: - SelectThemeColorPresentation

extension SelectThemeColorPresenter: SelectThemeColorPresentation {
    public func didTapColor(color: CardPackageThemeColor) {
        Task { @MainActor in
            dependency.repository.updateThemeColor(
                cardPackageId: dependency.cardPackageId,
                themeColor: color.rawValue)

            applySelectedThemeColor(color)
            showSuccess(message: "テーマカラーを\(color)に変更しました")
        }
    }

    // MARK: - Presentation

    public func viewDidLoad() {
        showColorList()
    }

    public func viewDidResume() {
        showColorList()
    }

    public func viewDidSuspend() {}
}
