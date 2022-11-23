import Neumorphic
import SwiftUI

struct CardListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /// ルーム
    var room: Room

    /// カレントユーザーID
    var currentUserId: String
    
    init(room: Room, currentUserId: String) {
        self.room = room
        self.currentUserId = currentUserId
    }
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            ScrollView {
                HStack {
                    Text("\(String(room.userIdList.count)) members in Room ID: \(room.id)")
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
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Private
    
    private var roomDataStore = RoomDataStore()
    
    private func leaveRoom() async {
        await roomDataStore.removeUserFromRoom(roomId: room.id, userId: currentUserId)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView(room: .init(id: 0,
                                 userIdList: ["0"],
                                 cardPackage: CardPackage.sampleCardPackage),
                     currentUserId: "0")
    }
}
