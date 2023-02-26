import Neumorphic
import SwiftUI

struct CardView: View {
    /// カード
    var card: CardPackage.Card

    /// テーマカラー
    var themeColor: CardPackage.ThemeColor

    /// 有効か
    var isEnabled: Bool

    /// 選択されているか
    var isSelected: Bool

    /// カード選択ハンドラー
    var selectCardHandler: ((CardPackage.Card) -> Void)?

    // MARK: - View

    var body: some View {
        Button(action: {
            selectCardHandler?(card)
        }) {
            Text(card.point)
                .frame(width: 150, height: 100)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(card.fontColor)
                .background(card.backgroundColor(color: themeColor))
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? .gray : .clear, lineWidth: 2)
                }
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

struct CardView_Previews: PreviewProvider {
    static let card1 = CardPackage.defaultCardList.first!

    static let card2 = CardPackage.defaultCardList[
        Int(floor(CGFloat((card1.index + card3.index)) / 2))]

    static let card3 = CardPackage.defaultCardList.last!

    static var previews: some View {
        Group {
            CardView(
                card: card1,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: false
            )
            .previewDisplayName("色/薄い")

            CardView(
                card: card2,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: false
            )
            .previewDisplayName("色/中間")

            CardView(
                card: card3,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: false
            )
            .previewDisplayName("色/濃い")

            CardView(
                card: card1,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: true
            )
            .previewDisplayName("選択されている")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
