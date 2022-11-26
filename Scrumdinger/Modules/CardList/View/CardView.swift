import SwiftUI

struct CardView: View {
    /// カード
    var card: Card
    
    /// テーマカラー
    var themeColor: ThemeColor
        
    // MARK: - View
    
    var body: some View {
        Button(action: {
            // TODO: ユーザーの選択済みカードに指定
        }) {
            Text("\(card.point)")
                .frame(width: 160, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(card.fontColor)
                .background(card.outputBackgroundColor(color: themeColor))
                .border(LinearGradient(gradient: Gradient(colors: [.white, Color(themeColor.rawValue)]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing),
                        width: 2)
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
