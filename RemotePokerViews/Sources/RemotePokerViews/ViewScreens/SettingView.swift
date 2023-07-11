import SettingDomain
import SwiftUI

public struct SettingView: View {
    @Environment(\.presentationMode) var presentation

    // MARK: - Dependency

    struct Dependency {
        var presenter: SettingPresentation
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

    private var contentView: some View {
        VStack(alignment: .leading) {
            List {
                selecteThemeColorButton
                    .disabled(!viewModel.isButtonEnabled)
                leaveButton
                    .disabled(!viewModel.isButtonEnabled)
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
    }

    /// 退出ボタン
    private var leaveButton: some View {
        Button(action: {
            Task {
                await dependency.presenter.didTapLeaveRoomButton()
                presentation.wrappedValue.dismiss()
            }
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .foregroundColor(.gray)
                Text("ルームから退出")
                    .foregroundColor(.gray)
            }
        }
    }

    /// 通知バナー
    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, viewModel: viewModel.bannerMessgage)
    }
}

// MARK: - ModuleAssembler

extension SettingView: ModuleAssembler {
    /// テーマカラー選択画面へ遷移させるナビゲーション
    private var navigationForSelectThemeColorView: some View {
        NavigationLink(
            isActive: $viewModel.willPushSelectThemeColorView,
            destination: {
                assembleSelectThemeColorModule()
            }
        ) { EmptyView() }
    }
}

// MARK: - Preview

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(
            dependency: .init(presenter: SettingPresenter(), cardPackageId: "1"),
            viewModel: .init()
        )
    }
}
