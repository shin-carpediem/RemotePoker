import SwiftUI

struct SelectThemeColorView: View {
    @Environment(\.presentationMode) var presentation

    // MARK: - Dependency

    struct Dependency {
        var presenter: SelectThemeColorPresentation
    }

    init(dependency: Dependency, viewModel: SelectThemeColorViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }

    // MARK: - Private

    private var dependency: Dependency

    @ObservedObject private var viewModel: SelectThemeColorViewModel

    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, message: viewModel.bannerMessgage)
    }

    // MARK: - View

    var body: some View {
        ZStack {
            contentView
            if viewModel.isShownLoader { Loader() }
        }
        .navigationTitle("テーマカラー")
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    /// コンテンツビュー
    private var contentView: some View {
        VStack(alignment: .leading) {
            List(viewModel.themeColorList, id: \.self) { color in
                colorCell(color)
            }
            .listBackground(Colors.background)
            .listStyle(.insetGrouped)
        }
    }

    /// カラーセル
    private func colorCell(_ color: CardPackageEntity.ThemeColor) -> some View {
        let isThemeColor = color == viewModel.selectedThemeColor
        return Button {
            dependency.presenter.didTapColor(color: color)
        } label: {
            if isThemeColor {
                themeLabel(color)
            } else {
                label(color)
            }
        }
        .disabled(!viewModel.isButtonEnabled)
    }

    /// テーマラベル
    private func themeLabel(_ color: CardPackageEntity.ThemeColor) -> some View {
        Text(color.rawValue)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.gray)
    }

    /// ラベル
    private func label(_ color: CardPackageEntity.ThemeColor) -> some View {
        Text(color.rawValue)
            .foregroundColor(.gray)
    }
}

// MARK: - Preview

struct SelectThemeColorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectThemeColorView(
            dependency: .init(presenter: SelectThemeColorPresenter()),
            viewModel: .init()
        )
        .previewDisplayName("テーマカラー選択画面")
    }
}
