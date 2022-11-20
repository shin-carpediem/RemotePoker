import Neumorphic
import SwiftUI

struct CardListView: View {
    /// ルーム
    @State var roomToEnter = RoomModel()

    /// ユーザーID
    @State var userId = UUID().uuidString

    @Binding var isNewRoom: Bool

    @Binding var existingRoomId: String

    @Binding var userIdList: [String]
    
    var body: some View {
        // TODO: isNewRoomの値がtrueに更新されるよりも前にViewを描画してしまう
        let roomId = isNewRoom ? roomToEnter.id : existingRoomId
        var userIdList = isNewRoom ? roomToEnter.userIdList : userIdList
        let usersCount = isNewRoom ? userIdList.count : userIdList.count + 1
        
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            ScrollView {
                HStack {
                    Text("\(String(usersCount)) members in Room ID: \(roomId)")
                        .font(.headline)
                        .padding()

                    Button(action: {
                        leaveRoom(roomId: roomId, usersIdList: &userIdList)
                        dismiss()
                    }) {
                        Text("Leave")
                            .foregroundColor(.blue)
                    }
                }

                Spacer()

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
                    ForEach(cardList) { eachCard in
                        CardView(id: cardList.firstIndex(of: eachCard) ?? 0,
                                 color: cardListWithColor.color,
                                 card: eachCard,
                                 cardList: cardListWithColor)
                    }
                    .padding()
                }
            }
            .onAppear {
                isNewRoom ? createRoomAndAddUser() : addUserToExistingRoom(roomId: roomId, usersIdList: &userIdList)
            }
        }
    }
    
    // MARK: - Private
    
    /// モーダルを解除する
    @Environment(\.dismiss) private var dismiss
    
    /// カード一覧 + 色
    private let cardListWithColor = CardListModel.sampleData

    /// カード一覧
    private let cardList = CardListModel.numberSetSampleData
    
    private func createRoomAndAddUser() {
        roomToEnter = RoomModel()
        roomToEnter.createRoom()
        roomToEnter.addUserToRoom(roomId: roomToEnter.id,
                                  userId: userId,
                                  userIdList: &roomToEnter.userIdList)
    }
    
    private func addUserToExistingRoom(roomId: String, usersIdList: inout [String]) {
        roomToEnter.addUserToRoom(roomId: roomId,
                                  userId: userId,
                                  userIdList: &usersIdList)
    }
    
    private func leaveRoom(roomId: String, usersIdList: inout [String]) {
        roomToEnter.removeUserFromRoom(roomId: roomId,
                                       userId: userId,
                                       userIdList: &usersIdList)
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static let sampleData = RoomModel.sampleData
    
    static var previews: some View {
        CardListView(roomToEnter: sampleData,
                     userId: UUID().uuidString,
                     isNewRoom: .constant(false),
                     existingRoomId: .constant("0"),
                     userIdList: .constant([]))
    }
}
