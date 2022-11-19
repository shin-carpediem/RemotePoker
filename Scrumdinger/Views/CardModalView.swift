import Neumorphic
import SwiftUI

struct CardModalView: View {
    /// ID
    let id: Int

    /// 色
    let color: Color
    
    /// カード
    let card: CardListModel.Card
    
    /// カード一覧
    let cardList: CardListModel

    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            Text("\(card.point)")
                .frame(width: 300, height: 400)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(card.outputForegroundColor(id))
                .background(card.outputCardColor(id, color))
                .border(LinearGradient(gradient: Gradient(colors: [.white, color]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing),
                        width: 2)
                // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
                .cornerRadius(20)
        }
    }
}

// MARK: - Preview

struct CardModalView_Previews: PreviewProvider {
    static var cardNumberSet = CardListModel.sampleData
    static var cardNumber = cardNumberSet.cardList[0]
    
    static var previews: some View {
        CardModalView(id: 1,
                      color: .green,
                      card: cardNumber,
                      cardList: cardNumberSet)
    }
}
