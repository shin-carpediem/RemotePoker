import Neumorphic
import SwiftUI

struct CardListView: View, ModuleAssembler {
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: CardListPresenter
        var room: Room
        var currentUser: User
    }
    
    init(dependency: Dependency, viewModel: CardListViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: CardListViewModel
    
    /// View生成時
    private func construct() async {
        dependency.presenter.subscribeUser()
        await dependency.presenter.outputHeaderTitle()
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Neumorphic.main.ignoresSafeArea()
                VStack {
                    ScrollView {
                        headerTitle
                            .padding([.leading, .trailing])
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
                            .background(.clear).opacity(0)
                        floatingActionButton
                    }
                }
                navigationForSettingView
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task { await construct() }
        }
    }
    
    /// ヘッダータイトル
    private var headerTitle: some View {
        HStack {
            headerText
                .padding()
            Spacer()
            settingButton
        }
    }
    
    /// ヘッダーテキスト
    private var headerText: some View {
        Text(viewModel.headerTitle)
            .font(.headline)
            .foregroundColor(.gray)
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
            ForEach(dependency.room.cardPackage.cardList) { card in
                let themeColor = dependency.room.cardPackage.themeColor
                CardView(card: card,
                         themeColor: themeColor) { selectedCard in
                    Task {
                        await dependency.presenter.didSelectCard(card: selectedCard)
                    }
                }
            }
        }
    }
    
    /// 選択済みカード一覧
    private var selectedCardListView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
            ForEach(viewModel.userSelectStatus) { userSelect in
                OpenCardView(userSelectStatus: userSelect)
            }
        }
    }
    
    /// フローティングアクションボタン
    private var floatingActionButton: some View {
        Button {
            if viewModel.isShownSelectedCardList {
                Task {
                    await dependency.presenter.didTapResetSelectedCardListButton()
                }
            } else {
                dependency.presenter.didTapOpenSelectedCardListButton()
            }
        } label: {
            let systemName = viewModel.isShownSelectedCardList ? "gobackward" : "lock.rotation.open"
            return Image(systemName: systemName).foregroundColor(.gray)
        }
        .frame(width: 60, height: 60)
        .background(.white)
        .cornerRadius(30)
        .shadow(radius: 3)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16))
    }
    
    // MARK: - Router
    
    /// 設定画面へ遷移させるナビゲーション
    private var navigationForSettingView: some View {
        NavigationLink(isActive: $viewModel.willPushSettingView, destination: {
            if viewModel.willPushSettingView {
                assembleSetting(room: dependency.room,
                                currrentUser: dependency.currentUser)
            } else { EmptyView() }
        }) { EmptyView() }
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static let cardListView: CardListViewModel = {
        let viewModel = CardListViewModel()
        viewModel.userSelectStatus = []
        viewModel.isShownSelectedCardList = false
        return viewModel
    }()
    
    static let selectedCardListView: CardListViewModel = {
        let viewModel = CardListViewModel()
        viewModel.userSelectStatus = [
            .init(id: 0,
                  user: CardListView_Previews.me,
                  themeColor: .navy,
                  selectedCard: CardView_Previews.card1),
            .init(id: 1,
                  user: CardListView_Previews.user1,
                  themeColor: .indigo,
                  selectedCard: CardView_Previews.card2),
            .init(id: 2,
                  user: CardListView_Previews.user2,
                  themeColor: .buttercup,
                  selectedCard: CardView_Previews.card3)
        ]
        viewModel.isShownSelectedCardList = true
        return viewModel
    }()
    
    static let me: User = .init(id: "0",
                                name: "ロイド フォージャ",
                                selectedCardId: "")
    
    static let user1: User = .init(id: "1",
                                   name: "ヨル フォージャ",
                                   selectedCardId: "")
    
    static let user2: User = .init(id: "2",
                                   name: "アーニャ フォージャ",
                                   selectedCardId: "")
    
    static let room1: Room = .init(id: 0,
                                   userList: [me],
                                   cardPackage: .sampleCardPackage)
    
    static let room2: Room = .init(id: 1,
                                   userList: [me, me],
                                   cardPackage: .sampleCardPackage)
    
    static var previews: some View {
        Group {
            CardListView(dependency: .init(
                presenter: .init(
                    dependency: .init(
                        dataStore: .init(),
                        room: room1,
                        currentUser: me,
                        viewModel: cardListView)),
                room: room1,
                currentUser: me),
                         viewModel: cardListView)
            .previewDisplayName("カード一覧画面/ユーザーが自分のみ")
            
            CardListView(dependency: .init(
                presenter: .init(
                    dependency: .init(
                        dataStore: .init(),
                        room: room2,
                        currentUser: me,
                        viewModel: cardListView)),
                room: room2,
                currentUser: me),
                         viewModel: cardListView)
            .previewDisplayName("カード一覧画面/ユーザーが2名以上")
            
            CardListView(dependency: .init(
                presenter: .init(
                    dependency: .init(
                        dataStore: .init(),
                        room: room2,
                        currentUser: me,
                        viewModel: selectedCardListView)),
                room: room1,
                currentUser: me),
                         viewModel: selectedCardListView)
            .previewDisplayName("選択済みカード一覧画面")
        }
    }
}
