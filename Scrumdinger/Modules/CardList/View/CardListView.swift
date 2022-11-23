import Neumorphic
import SwiftUI

struct CardListView: View {
    @Environment(\.dismiss) var dismiss
    
    /// ルーム
    var room: Room

    /// カレントユーザーID
    var currentUserId: String
    
    init(room: Room, currentUserId: String) {
        self.room = room
        self.currentUserId = currentUserId
    }
    
    var body: some View {
        let usersCount = room.userIdList.count
        
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            ScrollView {
                HStack {
                    Text("\(String(usersCount)) member" + (usersCount == 1 ? "" : "s") + " in Room ID: \(room.id)")
                        .font(.headline)
                        .padding()

                    Button(action: {
                        Task {
                            await leaveRoom()
                        }
                    }) {
                        Text("Leave")
                            .foregroundColor(.blue)
                    }
                }

                Spacer()

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 176))]) {
                    ForEach(room.cardPackage.cardList) { card in
                        CardView(card: card,
                                 themeColor: room.cardPackage.themeColor)
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Private
    
    private var roomDataStore = RoomDataStore()
    
    private func leaveRoom() async {
        await roomDataStore.removeUserFromRoom(roomId: room.id, userId: currentUserId)
        dismiss()
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardListView(room: .init(id: 1000,
                                     userIdList: ["0"],
                                     cardPackage: .sampleCardPackage),
                         currentUserId: "0")
            .previewDisplayName("ユーザーが自分のみ")
            
            // TODO: 環境変数 presentationMode の影響か、複数Previewを表示しようとするとクラッシュする
            CardListView(room: .init(id: 1001,
                                     userIdList: ["0", "1"],
                                     cardPackage: .sampleCardPackage),
                         currentUserId: "0")
            .previewDisplayName("ユーザーが2名以上")
        }
    }
}
