import EnterRoomDomain
import Neumorphic
import Shared
import SwiftUI

public struct EnterRoomView: View {
    // MARK: Dependency

    struct Dependency {
        var presenter: EnterRoomPresentation
    }

    init(dependency: Dependency, viewModel: EnterRoomViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }

    // MARK: Private

    private var dependency: Dependency!
    @ObservedObject private var viewModel: EnterRoomViewModel

    private var appConfig: AppConfig {
        guard let appConfig = AppConfigManager.appConfig else {
            fatalError()
        }
        return appConfig
    }
    
    // MARK: View

    public var body: some View {
        NavigationView {
            ZStack {
                Colors.background.ignoresSafeArea()
                contentView
                navigationForCardListView
                if viewModel.isLoaderShown { ProgressView() }
            }
        }
        // NavigationViewを使用した際にiPadでは、Master-Detail(Split view)の挙動になっている。
        // そしてMasterとなるViewが配置されていない為、空白のViewが表示されてしまう。
        // iPadはサポート外なので、iPhoneでもiPadでも同じ見た目に固定する。
        .navigationViewStyle(.stack)
        .modifier(Overlay(isShown: $viewModel.isBannerShown, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    private var contentView: some View {
        VStack(spacing: 28) {
            inputField
            validatedMessage
            sendButton
                .disabled(!viewModel.isButtonsEnabled)
                .padding()
        }
        .padding(.horizontal, 40)
    }
}

// MARK: View Components

extension EnterRoomView {
    /// 入力フォーム
    private var inputField: some View {
        HStack(spacing: 14) {
            InputText(text: $viewModel.inputName, placeholder: "名前")
            InputText(text: $viewModel.inputRoomId, placeholder: "ルームID")
        }
    }

    /// 入力フォーム内容が有効か評価されて表示されるメッセージ
    private var validatedMessage: some View {
        let textColor: Color = viewModel.isInputFormValid ? .green : .red
        return Text(viewModel.isInputFormValid ? "数字が新しければ新しいルームが作られます" : "6文字以下の名前と4桁の数字が必要です")
            .foregroundColor(textColor.opacity(0.7))
    }

    /// 送信ボタン
    private var sendButton: some View {
        Button {
            dependency.presenter.didTapEnterRoomButton(
                inputUserName: viewModel.inputName, inputRoomId: viewModel.inputRoomId)
        } label: {
            Text("入る")
                .frame(width: 140, height: 20)
        }
        .softButtonStyle(RoundedRectangle(cornerRadius: 20))
    }

    /// 通知バナー
    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isBannerShown, viewModel: viewModel.bannerMessgage)
    }
}

// MARK: ModuleAssembler

extension EnterRoomView: ModuleAssembler {
    /// カード一覧画面に遷移させるナビゲーション
    private var navigationForCardListView: some View {
        NavigationLink(
            isActive: $viewModel.willPushCardListView,
            destination: {
                assembleCardListModule()
            }
        ) { EmptyView() }
    }
}

// MARK: Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView(dependency: .init(presenter: EnterRoomPresenter()), viewModel: .init())
    }
}
