import SwiftUI

struct OpenCardView: View {
    /// 選択されたカード
    var selectedCard: SelectedCard
    
    // MARK: - View
    
    var body: some View {
        VStack {
            Text(selectedCard.user.name)
            
            Text(selectedCard.card.point)
                .frame(width: 170, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(selectedCard.card.fontColor)
                .background(selectedCard.card.outputBackgroundColor(color: selectedCard.themeColor))
                .cornerRadius(10)
        }
    }
}

// MARK: - Preview

struct OpenCardView_Previews: PreviewProvider {
    static var previews: some View {
        OpenCardView(selectedCard: .init(
            id: 0,
            user: CardListView_Previews.me,
            card: CardView_Previews.card1,
            themeColor: .bubblegum))
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
