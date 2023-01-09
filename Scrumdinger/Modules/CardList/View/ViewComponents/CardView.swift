import SwiftUI

struct CardView: View {
    /// カード
    var card: Card
    
    /// テーマカラー
    var themeColor: ThemeColor
    
    /// 選択されているか
    var isSelected: Bool
    
    /// カード選択ハンドラー
    var selectCardHandler: ((Card) -> Void)?
    
    // MARK: - View
    
    var body: some View {
        cardView
    }
    
    /// カードビュー
    private var cardView: some View {
        Button(action: {
            selectCardHandler?(card)
        }) {
            Text(card.point)
                .frame(width: 150, height: 100)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(card.fontColor)
                .background(card.outputBackgroundColor(color: themeColor))
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? .gray : .clear, lineWidth: 2)
                }
        }
    }
}

// MARK: - Preview

struct CardView_Previews: PreviewProvider {
    static let card1 = CardPackage.defaultCardList.first!
    
    static let card2 = CardPackage.defaultCardList[Int(floor(CGFloat((card1.index + card3.index)) / 2))]
    
    static let card3 = CardPackage.defaultCardList.last!
    
    static var previews: some View {
        Group {
            CardView(card: card1,
                     themeColor: .bubblegum,
                     isSelected: false)
            .previewDisplayName("色/薄い")
            
            CardView(card: card2,
                     themeColor: .bubblegum,
                     isSelected: false)
            .previewDisplayName("色/中間")

            CardView(card: card3,
                     themeColor: .bubblegum,
                     isSelected: false)
            .previewDisplayName("色/濃い")
            
            CardView(card: card1,
                     themeColor: .bubblegum,
                     isSelected: true)
            .previewDisplayName("選択されている")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
