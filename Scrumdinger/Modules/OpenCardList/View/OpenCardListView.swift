import Neumorphic
import SwiftUI

struct OpenCardListView: View {
    // MARK: - Dependency
    
    struct Dependency {
        var selectedCardList: [SelectedCard]
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
            ForEach(dependency.selectedCardList) { card in
                OpenCardView(selectedCard: card)
            }
            .padding()
        }
    }
}

// MARK: - Preview

struct OpenCardListView_Previews: PreviewProvider {
    static var previews: some View {
        OpenCardListView(dependency: .init(
            selectedCardList: [
                .init(id: 0,
                      user: CardListView_Previews.me,
                      card: CardView_Previews.card2,
                      themeColor: .bubblegum),
                
                    .init(id: 1,
                          user: CardListView_Previews.user1,
                          card: CardView_Previews.card3,
                          themeColor: .buttercup)
            ]))
    }
}
