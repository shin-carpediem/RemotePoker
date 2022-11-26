import Neumorphic
import SwiftUI

struct CardListView: View {
    @Environment(\.dismiss) var dismiss
        
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: CardListPresenter
        var room: Room
        var currentUser: User
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    // MARK: - View
    
    var body: some View {
        let usersCount = dependency.room.userList.count
        
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            ScrollView {
                HStack {
                    Text("\(String(usersCount)) member" + (usersCount == 1 ? "" : "s") + " in Room ID: \(dependency.room.id)")
                        .font(.headline)
                        .padding()

                    Button(action: {
                        Task {
                            await dependency.presenter.leaveRoom()
                            dismiss()
                        }
                    }) {
                        Text("Leave")
                            .foregroundColor(.blue)
                    }
                }

                Spacer()

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
                    ForEach(dependency.room.cardPackage.cardList) { card in
                        CardView(card: card,
                                 themeColor: dependency.room.cardPackage.themeColor)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static let me: User = .init(id: "0",
                                name: "ロイド フォージャ")
    
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
                        currentUser: me)),
                room: room1,
                currentUser: me))
            .previewDisplayName("ユーザーが自分のみ")
            
            // TODO: 環境変数 presentationMode の影響か、複数Previewを表示しようとするとクラッシュする
            CardListView(dependency: .init(
                presenter: .init(
                    dependency: .init(
                        dataStore: .init(),
                        room: room2,
                        currentUser: me)),
                room: room2,
                currentUser: me))
            .previewDisplayName("ユーザーが2名以上")
        }
    }
}
