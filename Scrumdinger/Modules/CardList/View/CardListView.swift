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
    
    init(dependency: Dependency, viewModel: CardListViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: CardListViewModel
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Neumorphic.main.ignoresSafeArea()
                VStack {
                    ScrollView {
                        headerTitle
                        Spacer()
                        cardListView
                    }
                    HStack {
                        Spacer()
                            .background(.clear).opacity(0)
                        floatingActionButton
                    }
                }
                destination
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerTitle: some View {
        HStack {
            Text(viewModel.headerTitle)
                .font(.headline)
                .padding()
                .foregroundColor(.gray)
            settingButton
        }
    }
    
    private var settingButton: some View {
        Button(action: {
            Task {
                await dependency.presenter.didTapLeaveRoomButton()
                presentation.wrappedValue.dismiss()
            }
        }) {
            Text("Leave")
                .foregroundColor(.gray)
        }
    }
    
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
            .padding()
        }
    }
    
    private var floatingActionButton: some View {
        Button {
            if viewModel.isOpenSelectedCardList {
                Task {
                    await dependency.presenter.didTapResetSelectedCardListButton()
                }
            } else {
                dependency.presenter.didTapOpenSelectedCardListButton()
            }
        } label: {
            buttonImage
        }
        .frame(width: 60, height: 60)
        .background(.white)
        .cornerRadius(30)
        .shadow(radius: 3)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16))
    }
    
    private var buttonImage: some View {
        let systemName = viewModel.isOpenSelectedCardList ? "gobackward" : "lock.rotation.open"
        return Image(systemName: systemName).foregroundColor(.gray)
    }
    
    // MARK: - Router
    
    private var destination: some View {
        NavigationLink(isActive: $viewModel.willPushNextView, destination: {
            if viewModel.willPushNextView {
                assembleOpenCardList(room: dependency.room,
                                     userSelectStatus: viewModel.userSelectStatus)
            } else { EmptyView() }
        }) { EmptyView() }
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static let me: User = .init(id: "0",
                                name: "ロイド フォージャ",
                                selectedCard: nil)
    
    static let user1: User = .init(id: "1",
                                   name: "ヨル フォージャ",
                                   selectedCard: nil)
    
    static let user2: User = .init(id: "2",
                                   name: "アーニャ フォージャ",
                                   selectedCard: nil)
    
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
                        viewModel: .init())),
                room: room1,
                currentUser: me),
                         viewModel: .init())
            .previewDisplayName("ユーザーが自分のみ")
            
            // TODO: 環境変数 presentationMode の影響か、複数Previewを表示しようとするとクラッシュする
            CardListView(dependency: .init(
                presenter: .init(
                    dependency: .init(
                        dataStore: .init(),
                        room: room2,
                        currentUser: me,
                        viewModel: .init())),
                room: room2,
                currentUser: me),
                         viewModel: .init())
            .previewDisplayName("ユーザーが2名以上")
        }
    }
}
