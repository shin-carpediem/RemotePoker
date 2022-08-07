import SwiftUI

struct PlanningPokerView: View {
    var room: RoomModel
    private let estimateNumberSet = EstimateNumberSetModel.sampleData
    private let numberSet = EstimateNumberSetModel.numberSetSampleData
    
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
        // TODO: 表示されてない
        .navigationTitle("\(String(room.usersId.count)) members in Room ID: \(room.id)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlanningPokerView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningPokerView(room: RoomModel.sampleData)
    }
}
