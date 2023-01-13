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
                Colors.screenBackground
                contentView
                navigationForCardListView
                if viewModel.isShownLoader { Loader() }
            }
        }
        .navigationTitle("RemotePoker")
        .alert(isPresented: $viewModel.isShownEnterCurrentRoomAlert,
               content: { enterCurrentRoomAlert })
        .alert("Name & 4 Digit Number Required",
               isPresented: $viewModel.isShownInputFormInvalidAlert,
               actions: {},
               message: { Text("If the number is new, a new room will be created.") })
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }
    
    /// コンテンツビュー
    private var contentView: some View {
        VStack(spacing: 28) {
            inputField
            sendButton
                .padding()
        }
        .padding(.horizontal, 40)
    }
    
    /// 入室中のルームに入るか促すアラート
    private var enterCurrentRoomAlert: Alert {
        .init(title: Text("Enter Existing Room?"),
              primaryButton: .default(Text("OK"), action: {
            dependency.presenter.didTapEnterCurrentRoomButton()
        }),
              secondaryButton: .cancel {
            dependency.presenter.didCancelEnterCurrentRoomButton()
        })
    }
    
    /// 入力フォーム
    private var inputField: some View {
        HStack(spacing: 14) {
            InputText(placeholder: "Name", text: $viewModel.inputName)
            InputText(placeholder: "Room ID", text: $viewModel.inputRoomId)
        }
    }
    
    /// 送信ボタン
    private var sendButton: some View {
        Button {
            dependency.presenter.didTapEnterRoomButton(
                inputUserName: viewModel.inputName, inputRoomId: viewModel.inputRoomId)
        } label: {
            Text("Enter")
                .frame(width: 140, height: 20)
        }
        .softButtonStyle(RoundedRectangle(cornerRadius: 20))
        .disabled(!viewModel.isButtonEnabled)
    }
    
    // MARK: - Router
    
    /// カード一覧画面に遷移させるナビゲーション
    private var navigationForCardListView: some View {
        NavigationLink(isActive: $viewModel.willPushCardListView, destination: {
            if viewModel.willPushCardListView {
                assembleCardList(roomId: dependency.presenter.currentRoom.id,
                                 currentUserId: dependency.presenter.currentUser.id,
                                 currentUserName: dependency.presenter.currentUser.name,
                                 cardPackageId: dependency.presenter.currentRoom.cardPackage.id)
            } else { EmptyView() }
        }) { EmptyView() }
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView(dependency: .init(presenter: EnterRoomPresenter()), viewModel: .init())
            .previewDisplayName("ルーム入室画面")
    }
}
