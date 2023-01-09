import SwiftUI

struct CardListView: View, ModuleAssembler {
    @Environment(\.presentationMode) var presentation
    
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: CardListPresentation
        var room: Room
        var currentUser: User
    }
    
    /// View生成時
    init(dependency: Dependency, viewModel: CardListViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: CardListViewModel
    
    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, message: viewModel.bannerMessgage)
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.background
            contentView
            navigationForSettingView
            if viewModel.isShownLoader { Loader() }
        }
        .navigationTitle(viewModel.headerTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: settingButton)
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }
    
    /// コンテンツビュー
    private var contentView: some View {
        VStack {
            ScrollView {
                Spacer()
                if viewModel.isShownSelectedCardList {
                    selectedCardListView
                        .padding()
                } else {
                    cardListView
                        .padding()
                }
            }
            HStack {
                Spacer()
                selectedCardPointView
                Spacer()
                buttonText
                floatingActionButton
            }
        }
    }
    
    /// 設定ボタン
    private var settingButton: some View {
        Button(action: {
            dependency.presenter.didTapSettingButton()
        }) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.gray)
        }
    }

    /// カード一覧
    private var cardListView: some View {
        let cardList = viewModel.room?.cardPackage.cardList ?? dependency.room.cardPackage.cardList
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(cardList) { card in
                let themeColor = viewModel.room?.cardPackage.themeColor ?? .oxblood
                let isSelected = card.id == dependency.currentUser.selectedCardId
                CardView(card: card,
                         themeColor: themeColor,
                         isSelected: isSelected) { selectedCard in
                    dependency.presenter.didSelectCard(card: selectedCard)
                }
            }
        }
    }
    
    /// 選択されたカード一覧
    private var selectedCardListView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(viewModel.userSelectStatusList) { userSelectStatus in
                OpenCardView(userSelectStatus: userSelectStatus)
            }
        }
    }
    
    /// 選択されたカードのポイント
    private var selectedCardPointView: some View {
        let currentUserSelectStatus = viewModel.userSelectStatusList.first(where: { $0.user.id == dependency.currentUser.id })
        let point = currentUserSelectStatus?.selectedCard?.point ?? ""
        return Text(point)
            .foregroundColor(.gray)
            .font(.system(size: 26, weight: .regular))
    }
    
    /// ボタンの説明テキスト
    private var buttonText: some View {
        let text = viewModel.isShownSelectedCardList ? "Reset Selected Cards" : "Open Selected Cards"
        return Text(text)
            .foregroundColor(.gray)
            .font(.system(size: 14, weight: .regular))
    }
    
    /// フローティングアクションボタン
    private var floatingActionButton: some View {
        Button {
            if viewModel.isShownSelectedCardList {
                dependency.presenter.didTapResetSelectedCardListButton()
            } else {
                dependency.presenter.didTapOpenSelectedCardListButton()
            }
        } label: {
            let selectedCardCount = viewModel.userSelectStatusList.map { $0.selectedCard }.count
            let systemName: String
            if viewModel.isShownSelectedCardList {
                systemName = "gobackward"
            } else {
                if selectedCardCount >= 3 {
                    systemName = "person.3.sequence"
                } else if selectedCardCount == 2 {
                    systemName = "person.2"
                } else {
                    systemName = "person"
                }
            }
            return Image(systemName: systemName).foregroundColor(.gray)
        }
        .softButtonStyle(Circle())
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
    
    // MARK: - Router
    
    /// 設定画面へ遷移させるナビゲーション
    private var navigationForSettingView: some View {
        NavigationLink(isActive: $viewModel.willPushSettingView, destination: {
            if viewModel.willPushSettingView {
                assembleSetting(room: dependency.room,
                                currentUser: dependency.currentUser)
                .onDisappear {
                    if !RoomAuthDataStore.shared.isUserLoggedIn() {
                        // ログアウトしている場合、ルート(=ひとつ前の画面)に遷移する
                        presentation.wrappedValue.dismiss()
                    }
                }
            } else { EmptyView() }
        }) { EmptyView() }
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static let selectedCardListView: CardListViewModel = {
        let viewModel = CardListViewModel()
        viewModel.userSelectStatusList = [
            .init(id: 0,
                  user: CardListView_Previews.me,
                  themeColor: .navy,
                  selectedCard: CardView_Previews.card1),
            .init(id: 1,
                  user: CardListView_Previews.user1,
                  themeColor: .indigo,
                  selectedCard: CardView_Previews.card2)
        ]
        viewModel.isShownSelectedCardList = true
        return viewModel
    }()

    static let me: User = .init(id: "0",
                                name: "ロイド フォージャ",
                                currentRoomId: 0,
                                selectedCardId: "")

    static let user1: User = .init(id: "1",
                                   name: "ヨル フォージャ",
                                   currentRoomId: 0,
                                   selectedCardId: "")

    static let user2: User = .init(id: "2",
                                   name: "アーニャ フォージャ",
                                   currentRoomId: 0,
                                   selectedCardId: "")

    static let room1: Room = .init(id: 0,
                                   userList: [me],
                                   cardPackage: .defaultCardPackage)

    static let room2: Room = .init(id: 1,
                                   userList: [me, user1],
                                   cardPackage: .defaultCardPackage)

    static var previews: some View {
        Group {
            CardListView(dependency: .init(presenter: CardListPresenter(),
                                           room: room1,
                                           currentUser: user1),
                         viewModel: .init())
            .previewDisplayName("カード一覧画面/ユーザーが自分のみ")

            CardListView(dependency: .init(presenter: CardListPresenter(),
                                           room: room2,
                                           currentUser: user1),
                         viewModel: .init())
            .previewDisplayName("カード一覧画面/ユーザーが2名以上")

            CardListView(dependency: .init(presenter: CardListPresenter(),
                                           room: room2,
                                           currentUser: user1),
                         viewModel: selectedCardListView)
            .previewDisplayName("選択済みカード一覧画面")
        }
    }
}
