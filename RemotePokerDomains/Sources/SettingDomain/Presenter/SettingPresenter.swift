import Foundation
import Protocols
import ViewModel

public final class SettingPresenter: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public weak var viewModel: SettingViewModel?

        public init(viewModel: SettingViewModel?) {
            self.viewModel = viewModel
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Private

    private var dependency: Dependency!

    @MainActor private func disableButton(_ disabled: Bool) {
        dependency.viewModel?.isButtonEnabled = !disabled
    }

    @MainActor private func showLoader(_ show: Bool) {
        dependency.viewModel?.isShownLoader = show
    }

    // MARK: - Router

    @MainActor private func pushSelectThemeColorView() {
        dependency.viewModel?.willPushSelectThemeColorView = true
    }
}

// MARK: - SettingPresentation

extension SettingPresenter: SettingPresentation {
    public func didTapSelectThemeColorButton() {
        Task {
            await pushSelectThemeColorView()
        }
    }

    // MARK: - Presentation

    public func viewDidLoad() {}

    public func viewDidResume() {}

    public func viewDidSuspend() {}
}

// MARK: - SettingInteractorOutput

extension SettingPresenter: SettingInteractorOutput {
    @MainActor public func outputSuccess(message: String) {
        dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
            type: .onSuccess, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    @MainActor public func outputError(_ errror: Error, message: String) {
        dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
            type: .onFailure, text: message)
        dependency.viewModel?.isShownBanner = true
    }
}
