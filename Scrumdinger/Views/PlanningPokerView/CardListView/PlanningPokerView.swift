import SwiftUI

struct PlanningPokerView: View {
    let estimateNumberSet = EstimateNumberSetModel.sampleData
    let numberSet = EstimateNumberSetModel.numberSetSampleData
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
                ForEach(numberSet) { eachCard in
                    PokerCardView(cardNumberSet: estimateNumberSet,
                        cardNumber: eachCard,
                        cardIndex: numberSet.firstIndex(of: eachCard) ?? 0,
                        cardColor: estimateNumberSet.color)
                }
                .padding()
            }
        }
    }
}

struct PlanningPokerView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningPokerView()
    }
}
