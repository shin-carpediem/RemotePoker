import Neumorphic
import SwiftUI

struct OpenCardListView: View {
    // MARK: - Dependency
    
    struct Dependency {
        var userSelectStatus: [UserSelectStatus]
        var room: Room
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()
            ScrollView {
                cardListView
            }
        }
    }
    
    private var cardListView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
            ForEach(dependency.userSelectStatus) { userSelect in
                OpenCardView(userSelectStatus: userSelect)
            }
            .padding()
        }
    }
}

// MARK: - Preview

struct OpenCardListView_Previews: PreviewProvider {
    static var previews: some View {
        OpenCardListView(dependency: .init(
            userSelectStatus: [
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
            ], room: CardListView_Previews.room1))
    }
}
