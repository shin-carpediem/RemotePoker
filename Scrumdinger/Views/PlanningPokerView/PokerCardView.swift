import SwiftUI

struct PokerCardView: View {
    @State private var isPresentedModal = false
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
        Button(action: {
            isPresentedModal = true
        }) {
            Text("\(cardNumber.number)")
                .frame(width: 160, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(outputForegroundColor(outputOpacity(cardIndex)))
                .background(outputCardColor(outputOpacity(cardIndex)))
                // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
                .cornerRadius(10)
        }
        .sheet(isPresented: $isPresentedModal) {
            NavigationView {
                PokerCardModalView(
                    cardNumberSet: cardNumberSet,
                    cardNumber: cardNumber,
                    cardIndex: cardIndex)
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
    static var estimateNumberSet = EstimateNumberSet.sampleData
    static var cardNumber0 = EstimateNumberSet.numberSetSampleData[0]
    static var cardNumber1 = EstimateNumberSet.numberSetSampleData[1]
    static var cardNumber2 = EstimateNumberSet.numberSetSampleData[2]
    
    static var previews: some View {
        Group {
            PokerCardView(cardNumberSet: estimateNumberSet, cardNumber: cardNumber0, cardIndex: 0)
            PokerCardView(cardNumberSet: estimateNumberSet, cardNumber: cardNumber1, cardIndex: 1)
            PokerCardView(cardNumberSet: estimateNumberSet, cardNumber: cardNumber2, cardIndex: 2)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
