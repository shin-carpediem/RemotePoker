import SwiftUI

struct PokerCardModalView: View {
    let cardNumber: EstimateNumber
    
    var body: some View {
        Text("\(cardNumber.number)")
            .frame(width: 300, height: 400)
            .font(.system(size: 80, weight: .bold))
            .foregroundColor(.white)
            .background(.yellow)
            // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
            .cornerRadius(20)
    }
}

struct PokerCardModalView_Previews: PreviewProvider {
    static var cardNumbr = EstimateNumber.sampleData[0]
    
    static var previews: some View {
        PokerCardModalView(cardNumber: cardNumbr)
    }
}
