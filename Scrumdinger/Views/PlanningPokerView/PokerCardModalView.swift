import SwiftUI

struct PokerCardModalView: View {
    let cardNumberSet: EstimateNumberSet
    let cardNumber: EstimateNumberSet.EstimateNumber
    let cardIndex: Int

    private func outputOpacity(_ cardIndex: Int) -> Double {
        let number: Int = cardIndex >= 10 ? 9 : cardIndex
        return Double("0.\(number)") ?? 1.0
    }
    
    private func outputCardColor(_ opacity: Double) -> Color {
        cardNumberSet.color.opacity(opacity)
    }
    
    private func outputForegroundColor(_ opacity: Double) -> Color {
        opacity >= 5.0 ? .white : .gray
    }
    
    var body: some View {
        Text("\(cardNumber.number)")
            .frame(width: 300, height: 400)
            .font(.system(size: 80, weight: .bold))
            .foregroundColor(outputForegroundColor(outputOpacity(cardIndex)))
            .background(outputCardColor(outputOpacity(cardIndex)))
            // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
            .cornerRadius(20)
    }
}

struct PokerCardModalView_Previews: PreviewProvider {
    static var cardNumberSet = EstimateNumberSet.sampleData
    static var cardNumber = cardNumberSet.numberSet[0]
    
    static var previews: some View {
        PokerCardModalView(cardNumberSet:cardNumberSet, cardNumber: cardNumber, cardIndex: 1)
    }
}
