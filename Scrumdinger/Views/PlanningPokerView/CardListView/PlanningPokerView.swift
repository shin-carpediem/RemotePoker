import SwiftUI

struct PlanningPokerView: View {
    @Environment(\.dismiss) private var dismiss
    var room: RoomModel
    let userId: UUID?
    
    // MARK: - Private
    
    private let estimateNumberSet = EstimateNumberSetModel.sampleData
    private let numberSet = EstimateNumberSetModel.numberSetSampleData
    
    private func leaveFromRoom() {
        if (userId == nil) { return }
        room.removeUserFromRoom(userId!)
    }
    
    // MARK: - View
    
    var body: some View {
        ScrollView {
            HStack {
                Text("\(String(room.usersId.count)) members in Room ID: \(room.id)")
                    .font(.headline)
                    .padding()
                Button(action: {
                    leaveFromRoom()
                    dismiss()
                }) {
                    Text("Leave")
                        .foregroundColor(.blue)
                }
            }
            Spacer()
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

// MARK: - Preview

struct PlanningPokerView_Previews: PreviewProvider {
    static let sampleData = RoomModel.sampleData
    
    static var previews: some View {
        PlanningPokerView(room: sampleData, userId: UUID())
    }
}
