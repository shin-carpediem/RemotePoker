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

    private var dependency: Dependency!
}

// MARK: - SettingPresentation

extension SettingPresenter: SettingPresentation {
    public func didTapSelectThemeColorButton() {
        pushSelectThemeColorView()
    }

    public func didTapLeaveRoomButton() async {
        updateButtons(isEnabled: false)
        updateLoader(isShown: true)

        await dependency.useCase.leaveRoom()

        updateButtons(isEnabled: true)
        updateLoader(isShown: false)
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
            dependency.viewModel?.isBannerShown = true
        }
    }

    public func outputError(_ errror: Error, message: String) {
        Task { @MainActor in
            dependency.viewModel?.bannerMessgage = NotificationBannerViewModel(
                type: .onFailure, text: message)
            dependency.viewModel?.isBannerShown = true
        }
    }
}

// MARK: - Private

extension SettingPresenter {
    private func updateButtons(isEnabled: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isButtonsEnabled = isEnabled
        }
    }

    private func updateLoader(isShown: Bool) {
        Task { @MainActor in
            dependency.viewModel?.isLoaderShown = isShown
        }
    }
    
    private func pushSelectThemeColorView() {
        Task { @MainActor in
            dependency.viewModel?.willPushSelectThemeColorView = true
        }
    }
}
