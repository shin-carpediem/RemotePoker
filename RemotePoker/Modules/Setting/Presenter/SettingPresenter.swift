import Foundation

final class SettingPresenter: SettingPresentation, SettingInteractorOutput, DependencyInjectable {
    // MARK: - DependencyInjectable

    struct Dependency {
        var useCase: SettingUseCase
        weak var viewModel: SettingViewModel?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - SettingPresentation

    func viewDidLoad() {}

    func viewDidResume() {}

    func viewDidSuspend() {}

    func didTapSelectThemeColorButton() {
        Task {
            await pushSelectThemeColorView()
        }
    }

    func didTapLeaveRoomButton() {
        Task {
            await disableButton(true)
            await showLoader(true)
            await dependency.useCase.leaveRoom()
            await disableButton(false)
            await showLoader(false)
        }
    }

    // MARK: - SettingInteractorOutput

    @MainActor
    func outputSuccess(message: String) {
        dependency.viewModel?.bannerMessgage = NotificationMessage(type: .onSuccess, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    @MainActor
    func outputError(_ errror: Error, message: String) {
        dependency.viewModel?.bannerMessgage = NotificationMessage(type: .onFailure, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    // MARK: - Private

    private var dependency: Dependency!

    /// ボタンを無効にする
    @MainActor
    private func disableButton(_ disabled: Bool) {
        dependency.viewModel?.isButtonEnabled = !disabled
    }

    /// ローダーを表示する
    @MainActor
    private func showLoader(_ show: Bool) {
        dependency.viewModel?.isShownLoader = show
    }

    // MARK: - Router

    /// テーマカラー選択画面に遷移する
    @MainActor
    private func pushSelectThemeColorView() {
        dependency.viewModel?.willPushSelectThemeColorView = true
    }
}
