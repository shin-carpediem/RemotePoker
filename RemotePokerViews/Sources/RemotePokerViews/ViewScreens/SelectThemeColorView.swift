import SelectThemeColorDomain
import SwiftUI
import ViewModel

public struct SelectThemeColorView: View {
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

    // MARK: - View

    public var body: some View {
        ZStack {
            contentView
            if viewModel.isShownLoader { ProgressView() }
        }
        .navigationTitle("テーマカラー")
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    private var contentView: some View {
        VStack(alignment: .leading) {
            List(viewModel.themeColorList, id: \.self) { color in
                colorCell(color)
                    .disabled(!viewModel.isButtonEnabled)
            }
            .listBackground(Colors.background)
            .listStyle(.insetGrouped)
        }
    }

    /// カラーセル
    private func colorCell(_ color: CardPackageThemeColor) -> some View {
        let isThemeColor: Bool = (color == viewModel.selectedThemeColor)
        return Button {
            dependency.presenter.didTapColor(color: color)
        } label: {
            if isThemeColor {
                themeLabel(color)
            } else {
                label(color)
            }
        }
    }

    /// テーマラベル
    private func themeLabel(_ color: CardPackageThemeColor) -> some View {
        Text(color.rawValue)
            .font(.headline)
            .foregroundColor(.gray)
    }

    /// ラベル
    private func label(_ color: CardPackageThemeColor) -> some View {
        Text(color.rawValue)
            .foregroundColor(.gray)
    }

    /// 通知バナー
    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, viewModel: viewModel.bannerMessgage)
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
