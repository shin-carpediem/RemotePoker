import Neumorphic
import SwiftUI

struct CardListView: View, ModuleAssembler {
    @Environment(\.presentationMode) var presentation
    
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: CardListPresenter
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
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()
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
            navigationForSettingView
        }
        .navigationTitle(viewModel.headerTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: settingButton)
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(dependency.room.cardPackage.cardList) { card in
                let themeColor = viewModel.themeColor
                let isSelected = card.id == dependency.currentUser.selectedCardId
                CardView(card: card,
                         themeColor: themeColor,
                         isSelected: isSelected) { selectedCard in
                    dependency.presenter.didSelectCard(card: selectedCard)
                }
            }
        }
    }
    
    /// 選択済みカード一覧
    private var selectedCardListView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(viewModel.userSelectStatus) { userSelect in
                OpenCardView(userSelectStatus: userSelect)
            }
        }
    }
    
    /// 選択されたカードのポイント
    private var selectedCardPointView: some View {
        let currentUserSelectStatus = viewModel.userSelectStatus.first(where: { $0.user.id == dependency.currentUser.id })
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
            let selectedCardCount = viewModel.userSelectStatus.map { $0.selectedCard }.count
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
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16))
    }
    
    // MARK: - Router
    
    /// 設定画面へ遷移させるナビゲーション
    private var navigationForSettingView: some View {
        NavigationLink(isActive: $viewModel.willPushSettingView, destination: {
            if viewModel.willPushSettingView {
                assembleSetting(room: dependency.room,
                                currrentUser: dependency.currentUser)
                .onDisappear {
                    // 設定画面から戻った時
                    if !AppConfig.shared.isCurrentUserLoggedIn {
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
                        interactor: .init(
                            dependency: .init(
                                dataStore: .init(),
                                room: room1)),
                        room: room1,
                        currentUser: me,
                        viewModel: .init())),
                room: room1,
                currentUser: me),
                         viewModel: .init())
            .previewDisplayName("カード一覧画面/ユーザーが自分のみ")
            
            CardListView(dependency: .init(
                presenter: .init(
                    dependency: .init(
                        interactor: .init(
                            dependency: .init(
                                dataStore: .init(),
                                room: room2)),
                        room: room2,
                        currentUser: me,
                        viewModel: .init())),
                room: room2,
                currentUser: me),
                         viewModel: .init())
            .previewDisplayName("カード一覧画面/ユーザーが2名以上")
            
            CardListView(dependency: .init(
                presenter: .init(
                    dependency: .init(
                        interactor: .init(
                            dependency: .init(
                                dataStore: .init(),
                                room: room2)),
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
