import SwiftUI

struct PokerCardView: View {
    @State private var isPresentedModal = false
    let cardNumber: EstimateNumber

    var body: some View {
        Button(action: {
            isPresentedModal = true
        }) {
            Text("\(cardNumber.number)")
                .frame(width: 160, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .background(.yellow)
                // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
                .cornerRadius(10)
        }
        .sheet(isPresented: $isPresentedModal) {
            NavigationView {
                PokerCardModalView(cardNumber: cardNumber)
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
    static var cardNumbr = EstimateNumber.sampleData[0]

    static var previews: some View {
        PokerCardView(cardNumber: cardNumbr)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
