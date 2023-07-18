import Foundation
import Protocols
import RemotePokerData
import Shared
import ViewModel

public final class SelectThemeColorPresenter: DependencyInjectable {
    public init() {}

    // MARK: DependencyInjectable

    public struct Dependency {
        public var repository: CurrentRoomRepository
        public weak var viewModel: SelectThemeColorViewModel?

        public init(
            repository: CurrentRoomRepository, viewModel: SelectThemeColorViewModel?
        ) {
            self.repository = repository
            self.viewModel = viewModel
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    private var dependency: Dependency!
}

// MARK: SelectThemeColorPresentation

extension SelectThemeColorPresenter: SelectThemeColorPresentation {
    public func didTapColor(color: CardPackageThemeColor) {
        Task { @MainActor in
            guard let appConfig = AppConfigManager.appConfig else {
                fatalError()
            }
            dependency.repository.updateThemeColor(
                cardPackageId: String(appConfig.currentRoom.cardPackage.id),
                themeColor: color.rawValue)
            applySelectedThemeColor(color)
            showSuccess(message: "テーマカラーを\(color)に変更しました")
        }
    }

    // MARK: Presentation

    public func viewDidLoad() {
        showColorList()
    }

    public func viewDidResume() {}

    public func viewDidSuspend() {}
}

// MARK: Private

extension SelectThemeColorPresenter {
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
            dependency.viewModel?.isBannerShown = true
        }
    }
}
