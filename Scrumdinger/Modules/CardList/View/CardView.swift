import SwiftUI

struct CardView: View {
    /// カード
    var card: Card
    
    /// テーマカラー
    var themeColor: ThemeColor
    
    /// カード選択ハンドラー
    var selectCardHandler: ((Card) -> Void)?
    
    // MARK: - View
    
    var body: some View {
        Button(action: {
            selectCardHandler?(card)
        }) {
            Text("\(card.point)")
                .frame(width: 170, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(card.fontColor)
                .background(card.outputBackgroundColor(color: themeColor))
                .cornerRadius(10)
        }
    }
}

// MARK: - Preview

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(card: CardPackage.sampleCardList[0],
                     themeColor: .bubblegum)
            .previewDisplayName("色/薄い")
            
            CardView(card: CardPackage.sampleCardList[4],
                     themeColor: .bubblegum)
            .previewDisplayName("色/中間")

            CardView(card: CardPackage.sampleCardList[9],
                     themeColor: .bubblegum)
            .previewDisplayName("色/濃い")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
