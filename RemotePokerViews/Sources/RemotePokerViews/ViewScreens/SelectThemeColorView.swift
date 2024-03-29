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
            if viewModel.isLoaderShown { ProgressView() }
        }
        .navigationTitle("テーマカラー")
        .modifier(Overlay(isShown: $viewModel.isBannerShown, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    private var contentView: some View {
        VStack(alignment: .leading) {
            List(viewModel.themeColorList, id: \.self) {
                colorCell($0)
                    .disabled(!viewModel.isButtonsEnabled)
            }
            .listBackground(Colors.background)
            .listStyle(.insetGrouped)
        }
    }
}

// MARK: - View Components

extension SelectThemeColorView {
    /// カラーセル
    private func colorCell(_ color: CardPackageThemeColor) -> some View {
        Button {
            dependency.presenter.didTapColor(color: color)
        } label: {
            if color == viewModel.selectedThemeColor {
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
        .init(isShown: $viewModel.isBannerShown, viewModel: viewModel.bannerMessgage)
    }
}

// MARK: - Preview

#Preview {
    SelectThemeColorView(
        dependency: .init(presenter: SelectThemeColorPresenter()),
        viewModel: .init()
    )
}
