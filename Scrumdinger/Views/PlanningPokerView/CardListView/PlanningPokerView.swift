import SwiftUI

struct PlanningPokerView: View {
    @State var roomToEnter = RoomModel()
    @State var userId = UUID().uuidString
    @Binding var isNewRoom: Bool
    @Binding var existingRoomId: String
    @Binding var usersIdList: [String]
    
    // MARK: - Private
    
    @Environment(\.dismiss) private var dismiss
    
    private let estimateNumberSet = EstimateNumberSetModel.sampleData
    private let numberSet = EstimateNumberSetModel.numberSetSampleData
    
    private func createRoomAndRegisterUser() {
        roomToEnter = RoomModel()
        roomToEnter.createRoom()
        roomToEnter.addUserToRoom(roomId: roomToEnter.id, userId: userId, usersIdList: &roomToEnter.usersId)
    }
    
    private func registerUserToExistingRoom(roomId: String, usersIdList: inout [String]) {
        roomToEnter.addUserToRoom(roomId: roomId, userId: userId, usersIdList: &usersIdList)
    }
    
    private func leaveFromRoom(roomId: String, usersIdList: inout [String]) {
        roomToEnter.removeUserFromRoom(roomId: roomId, userId: userId, usersIdList: &usersIdList)
    }
    
    // MARK: - View
    
    var body: some View {
        // TODO: isNewRoomの値がtrueに更新されるよりも前にViewを描画してしまう
        let roomId = isNewRoom ? roomToEnter.id : existingRoomId
        var usersIdList = isNewRoom ? roomToEnter.usersId : usersIdList
        let usersCount = isNewRoom ? usersIdList.count : usersIdList.count + 1
        ScrollView {
            HStack {
                Text("\(String(usersCount)) members in Room ID: \(roomId)")
                    .font(.headline)
                    .padding()
                Button(action: {
                    leaveFromRoom(roomId: roomId, usersIdList: &usersIdList)
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
            isNewRoom ? createRoomAndRegisterUser() : registerUserToExistingRoom(roomId: roomId, usersIdList: &usersIdList)
        }
    }
}

// MARK: - Preview

struct PlanningPokerView_Previews: PreviewProvider {
    static let sampleData = RoomModel.sampleData
    
    static var previews: some View {
        PlanningPokerView(roomToEnter: sampleData,
                          userId: UUID().uuidString,
                          isNewRoom: .constant(false),
                          existingRoomId: .constant("0"),
                          usersIdList: .constant([]))
    }
}
