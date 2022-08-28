import Neumorphic
import SwiftUI

struct CardModalView: View {
    let cardNumberSet: EstimateNumberSetModel
    let cardNumber: EstimateNumberSetModel.EstimateNumber
    let cardIndex: Int
    let cardColor: Color
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            Text("\(cardNumber.number)")
                .frame(width: 300, height: 400)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(cardNumber.outputForegroundColor(cardIndex))
                .background(cardNumber.outputCardColor(cardIndex, cardColor))
                .border(LinearGradient(gradient: Gradient(colors: [.white, cardColor]),
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
    static var cardNumberSet = EstimateNumberSetModel.sampleData
    static var cardNumber = cardNumberSet.numberSet[0]
    
    static var previews: some View {
        CardModalView(cardNumberSet:cardNumberSet,
                           cardNumber: cardNumber,
                           cardIndex: 1,
                           cardColor: .green)
    }
}
