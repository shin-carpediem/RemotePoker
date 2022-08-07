import SwiftUI

struct PokerCardView: View {
    @State private var isPresentedModal = false
    let cardNumberSet: EstimateNumberSetModel
    let cardNumber: EstimateNumberSetModel.EstimateNumber
    let cardIndex: Int
    let cardColor: Color
    
    var body: some View {
        Button(action: {
            isPresentedModal = true
        }) {
            Text("\(cardNumber.number)")
                .frame(width: 160, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(cardNumber.outputForegroundColor(cardIndex))
                .background(cardNumber.outputCardColor(cardIndex, cardColor))
                .border(LinearGradient(gradient: Gradient(colors: [.white, cardColor]), startPoint: .topLeading,endPoint: .bottomTrailing), width: 2)
                // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
                .cornerRadius(10)

        }
        .sheet(isPresented: $isPresentedModal) {
            NavigationView {
                PokerCardModalView(
                    cardNumberSet: cardNumberSet,
                    cardNumber: cardNumber,
                    cardIndex: cardIndex,
                    cardColor: cardColor)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {
                                isPresentedModal = false
                            }) {
                                Text("X")
                                    .font(.system(size: 32))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
            }
        }
    }
}

struct PokerCardView_Previews: PreviewProvider {
    static var estimateNumberSet = EstimateNumberSetModel.sampleData
    static var cardNumber0 = EstimateNumberSetModel.numberSetSampleData[0]
    static var cardNumber1 = EstimateNumberSetModel.numberSetSampleData[1]
    static var cardNumber2 = EstimateNumberSetModel.numberSetSampleData[2]
    
    static var previews: some View {
        Group {
            PokerCardView(cardNumberSet: estimateNumberSet,
                          cardNumber: cardNumber0,
                          cardIndex: 0,
                          cardColor: .green)
            PokerCardView(cardNumberSet: estimateNumberSet,
                          cardNumber: cardNumber1,
                          cardIndex: 1,
                          cardColor: .green)
            PokerCardView(cardNumberSet: estimateNumberSet,
                          cardNumber: cardNumber2,
                          cardIndex: 2,
                          cardColor: .green)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
