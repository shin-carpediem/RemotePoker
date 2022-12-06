import Neumorphic
import SwiftUI

struct CardListView: View {
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
    
    @ObservedObject private var viewModel: CardListViewModel
    
    private var dependency: Dependency
    
    // MARK: - View
    
    var body: some View {
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
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            dependency.presenter.outputHeaderTitle()
        }
    }
    
    private var headerTitle: some View {
        HStack {
            Text(viewModel.headerTitle)
                .font(.headline)
                .padding()
                .foregroundColor(.gray)
            
            Button(action: {
                Task {
                    await dependency.presenter.leaveRoom()
                    presentation.wrappedValue.dismiss()
                }
            }) {
                Text("Leave")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var cardListView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
            ForEach(dependency.room.cardPackage.cardList) { card in
                let themeColor = dependency.room.cardPackage.themeColor
                CardView(card: card,
                         themeColor: themeColor) { selectedCard in
                    Task {
                        await dependency.presenter.didSelectCard(cardId: selectedCard.id)
                    }
                }
            }
            .padding()
        }
    }
    
    private var floatingActionButton: some View {
        Button {
            dependency.presenter.openSelectedCardList()
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
        return Image(systemName: systemName)
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static let me: User = .init(id: "0",
                                name: "ロイド フォージャ",
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
