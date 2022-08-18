import SwiftUI

struct PlanningPokerView: View {
    @State var roomToEnter = RoomModel()
    @State var userId = UUID().uuidString
    
    // MARK: - Private
    
    @Environment(\.dismiss) private var dismiss
    
    private let estimateNumberSet = EstimateNumberSetModel.sampleData
    private let numberSet = EstimateNumberSetModel.numberSetSampleData
    
    private func createRoomAndRegisterUser() {
        roomToEnter.createRoom()
        roomToEnter.addUserToRoom(userId)
    }
    
    private func registerUserToExistingRoom() {
        roomToEnter.addUserToRoom(userId)
    }
    
    private func leaveFromRoom() {
        roomToEnter.removeUserFromRoom(userId)
        if roomToEnter.usersId.isEmpty {
            roomToEnter.deleteRoom()
        }
    }
    
    // MARK: - View
    
    var body: some View {
        ScrollView {
            HStack {
                Text("\(String(roomToEnter.usersId.count)) members in Room ID: \(roomToEnter.id)")
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
        .onAppear {
            createRoomAndRegisterUser()
        }
    }
}

// MARK: - Preview

struct PlanningPokerView_Previews: PreviewProvider {
    static let sampleData = RoomModel.sampleData
    
    static var previews: some View {
        PlanningPokerView(roomToEnter: sampleData,
                          userId: UUID().uuidString)
    }
}
