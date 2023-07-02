import Foundation
import Protocols
import ViewModel

public final class SettingPresenter: DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct Dependency {
        public var useCase: SettingUseCase
        public weak var viewModel: SettingViewModel?

        public init(useCase: SettingUseCase, viewModel: SettingViewModel?) {
            self.useCase = useCase
            self.viewModel = viewModel
        }
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - Private

    private var dependency: Dependency!

    private func disableButton(_ disabled: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isButtonEnabled = !disabled
        }
    }

    private func showLoader(_ show: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isShownLoader = show
        }
    }

    // MARK: - Router

    private func pushSelectThemeColorView() {
        Task { @MainActor in
            dependency.viewModel?.willPushSelectThemeColorView = true
        }
    }
}

// MARK: - SettingPresentation

extension SettingPresenter: SettingPresentation {
    public func didTapSelectThemeColorButton() {
        pushSelectThemeColorView()
    }

    public func didTapLeaveRoomButton() {
        disableButton(true)
        showLoader(true)
        Task {
            await dependency.useCase.leaveRoom()
            disableButton(false)
            showLoader(false)
        }
    }

    // MARK: - Presentation

    public func viewDidLoad() {}

    public func viewDidResume() {}

    public func viewDidSuspend() {}
}

// MARK: - SettingInteractorOutput

extension SettingPresenter: SettingInteractorOutput {
    public func outputSuccess(message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onSuccess, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }

    public func outputError(_ errror: Error, message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onFailure, text: message)
            dependency.viewModel?.isShownBanner = true
        }
    }
}
