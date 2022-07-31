import SwiftUI

struct PlanningPokerView: View {
//    @Binding var estimateNumber: [EstimateNumber]
    var estimateNumber = EstimateNumber.sampleData
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
                ForEach(estimateNumber) { eachNumber in
                    PokerCardView(cardNumber: eachNumber)
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
