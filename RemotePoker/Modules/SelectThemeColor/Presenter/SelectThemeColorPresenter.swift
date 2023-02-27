import Foundation

final class SelectThemeColorPresenter: SelectThemeColorPresentation,
    SelectThemeColorInteractorOutput, DependencyInjectable
{

    // MARK: - DependencyInjectable

    struct Dependency {
        var useCase: SelectThemeColorUseCase
        weak var viewModel: SelectThemeColorViewModel?
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - SelectThemeColorPresentation

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

    func didTapColor(color: CardPackageThemeColor) {
        dependency.useCase.updateThemeColor(themeColor: color)
    }

    // MARK: - SelectThemeColorInteractorOutput

    @MainActor
    func outputSelectedThemeColor(_ themeColor: CardPackageThemeColor) {
        dependency.viewModel?.selectedThemeColor = themeColor
        disableButton(false)
        showLoader(false)
    }

    @MainActor
    func outputSuccess(message: String) {
        dependency.viewModel?.bannerMessgage = NotificationMessage(type: .onSuccess, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    @MainActor
    func outputError(_ error: Error, message: String) {
        dependency.viewModel?.bannerMessgage = NotificationMessage(type: .onFailure, text: message)
        dependency.viewModel?.isShownBanner = true
    }

    // MARK: - Private

    private var dependency: Dependency!

    /// カラー一覧を表示する
    @MainActor
    private func showColorList() {
        dependency.viewModel?.themeColorList = CardPackageThemeColor.allCases
    }

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
}
