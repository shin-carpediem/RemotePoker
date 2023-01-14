import SwiftUI

struct SettingView: View, ModuleAssembler {
    @Environment(\.presentationMode) var presentation

    // MARK: - Dependency

    struct Dependency {
        var presenter: SettingPresentation
        var roomId: Int
        var cardPackageId: String
    }

    init(dependency: Dependency, viewModel: SettingViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }

    // MARK: - Private

    private var dependency: Dependency

    @ObservedObject private var viewModel: SettingViewModel

    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, message: viewModel.bannerMessgage)
    }

    // MARK: - View

    var body: some View {
        ZStack {
            Colors.screenBackground
            contentView
            navigationForSelectThemeColorView
            if viewModel.isShownLoader { Loader() }
        }
        .navigationTitle("Setting")
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    /// コンテンツビュー
    private var contentView: some View {
        VStack(alignment: .leading) {
            List {
                selecteThemeColorButton
                leaveButton
            }
            .listStyle(.insetGrouped)
        }
    }

    /// テーマカラー選択ボタン
    private var selecteThemeColorButton: some View {
        Button(action: {
            dependency.presenter.didTapSelectThemeColorButton()
        }) {
            HStack {
                Image(systemName: "heart")
                    .foregroundColor(.gray)
                Text("Select Theme Color")
                    .foregroundColor(.gray)
            }
        }
    }

    /// 退出ボタン
    private var leaveButton: some View {
        Button(action: {
            dependency.presenter.didTapLeaveRoomButton()
            presentation.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .foregroundColor(.gray)
                Text("Leave Room")
                    .foregroundColor(.gray)
            }
        }
        .disabled(!viewModel.isButtonEnabled)
    }

    // MARK: - Router

    /// テーマカラー選択画面へ遷移させるナビゲーション
    private var navigationForSelectThemeColorView: some View {
        NavigationLink(
            isActive: $viewModel.willPushSelectThemeColorView,
            destination: {
                if viewModel.willPushSelectThemeColorView {
                    assembleSelectThemeColor(
                        roomId: dependency.roomId,
                        cardPackageId: dependency.cardPackageId)
                } else {
                    EmptyView()
                }
            }
        ) { EmptyView() }
    }
}

// MARK: - Preview

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(
            dependency: .init(presenter: SettingPresenter(), roomId: 1, cardPackageId: "1"),
            viewModel: .init()
        )
        .previewDisplayName("設定画面")
    }
}
