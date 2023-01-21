import Neumorphic
import SwiftUI

struct EnterRoomView: View, ModuleAssembler {
    // MARK: - Dependency

    struct Dependency {
        var presenter: EnterRoomPresentation
    }

    init(dependency: Dependency, viewModel: EnterRoomViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }

    // MARK: - Private

    private var dependency: Dependency!

    @ObservedObject private var viewModel: EnterRoomViewModel

    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, message: viewModel.bannerMessgage)
    }

    // MARK: - View

    var body: some View {
        NavigationView {
            ZStack {
                Colors.background.ignoresSafeArea()
                contentView
                navigationForCardListView
                if viewModel.isShownLoader { Loader() }
            }
        }
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    /// コンテンツビュー
    private var contentView: some View {
        VStack(spacing: 28) {
            inputField
            validatedMessage
            sendButton
                .padding()
        }
        .padding(.horizontal, 40)
    }

    /// 入力フォーム
    private var inputField: some View {
        HStack(spacing: 14) {
            InputText(placeholder: "名前", text: $viewModel.inputName)
            InputText(placeholder: "ルームID", text: $viewModel.inputRoomId)
        }
    }

    /// 入力フォーム内容が有効か評価されて表示されるメッセージ
    private var validatedMessage: some View {
        let textColor: Color = viewModel.isInputFormValid ? .green : .red
        return Text(viewModel.inputFormvalidatedMessage)
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
        .disabled(!viewModel.isButtonEnabled)
    }

    // MARK: - Router

    /// カード一覧画面に遷移させるナビゲーション
    private var navigationForCardListView: some View {
        NavigationLink(
            isActive: $viewModel.willPushCardListView,
            destination: {
                // Viewの表示時に、以下の存在しないルームIDも以下に代入されてクラッシュするのを防ぐため、
                // willPushCardListView が評価されるタイミングで値を見るようにする
                if viewModel.willPushCardListView {
                    assembleCardList(
                        roomId: dependency.presenter.currentRoom.id,
                        currentUserId: dependency.presenter.currentUser.id,
                        currentUserName: dependency.presenter.currentUser.name,
                        cardPackageId: dependency.presenter.currentRoom.cardPackage.id)
                } else {
                    EmptyView()
                }
            }
        ) { EmptyView() }
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView(dependency: .init(presenter: EnterRoomPresenter()), viewModel: .init())
            .previewDisplayName("ルーム入室画面")
    }
}
