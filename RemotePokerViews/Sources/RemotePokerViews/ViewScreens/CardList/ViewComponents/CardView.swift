import Neumorphic
import RemotePokerDomains
import SwiftUI
import Translator
import ViewModel

struct CardView: View {
    var card: CardPackageViewModel.Card
    var themeColor: CardPackageThemeColor
    var isEnabled: Bool
    var isSelected: Bool
    var selectCardHandler: ((CardPackageViewModel.Card) -> Void)?

    // MARK: View

    var body: some View {
        Button(action: {
            selectCardHandler?(card)
        }) {
            Text(card.estimatePoint)
                .frame(width: 150, height: 100)
                .font(.largeTitle)
                .foregroundColor(card.fontColor)
                .background(card.backgroundColor)
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
    private static let defaultCardList = CardPackageModelToViewModelTranslator().translate(
        from: .defaultCardPackage
    ).cardList
    static let card1 = defaultCardList.first!
    static let card2 = defaultCardList[
        Int(floor(CGFloat((card1.index + card3.index)) / 2))]
    static let card3 = defaultCardList.last!

    static var previews: some View {
        VStack {
            Text("薄い色")
            CardView(
                card: card1,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: false
            )

            Text("中間の色")
            CardView(
                card: card2,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: false
            )

            Text("濃い色")
            CardView(
                card: card3,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: false
            )

            Text("選択されている")
            CardView(
                card: card1,
                themeColor: .bubblegum,
                isEnabled: true,
                isSelected: true
            )
        }
        .padding()
    }
}
