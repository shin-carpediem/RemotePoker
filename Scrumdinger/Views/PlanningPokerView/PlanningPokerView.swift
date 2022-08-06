import SwiftUI

struct PlanningPokerView: View {
    var estimateNumberSet = EstimateNumberSet.sampleData
    var numberSet: [EstimateNumber] {
        get { estimateNumberSet.numberSet }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
                ForEach(numberSet) { eachCard in
                    PokerCardView(
                        cardNumberSet: estimateNumberSet,
                        cardNumber: eachCard,
                        cardIndex: numberSet.firstIndex(of: eachCard) ?? 0
                    )
                }
                .padding()
            }
        }
        .navigationTitle("Planning Poker")
    }
}

struct PlanningPokerView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningPokerView()
    }
}
