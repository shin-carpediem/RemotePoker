import RemotePokerDomains
import SwiftUI

public struct SettingView: View, ModuleAssembler {
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

    // MARK: - View

    public var body: some View {
        ZStack {
            contentView
            navigationForSelectThemeColorView
            if viewModel.isShownLoader { ProgressView() }
        }
        .navigationTitle("設定")
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
            .listBackground(Colors.background)
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
                Text("テーマカラーの変更")
                    .foregroundColor(.gray)
            }
        }
        .disabled(!viewModel.isButtonEnabled)
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
                Text("ルームから退出")
                    .foregroundColor(.gray)
            }
        }
        .disabled(!viewModel.isButtonEnabled)
    }

    /// 通知バナー
    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, viewModel: viewModel.bannerMessgage)
    }

    // MARK: - Router

    /// テーマカラー選択画面へ遷移させるナビゲーション
    private var navigationForSelectThemeColorView: some View {
        NavigationLink(
            isActive: $viewModel.willPushSelectThemeColorView,
            destination: {
                assembleSelectThemeColorModule(
                    roomId: dependency.roomId,
                    cardPackageId: dependency.cardPackageId)
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
