import Neumorphic
import SwiftUI

struct EnterRoomView: View {
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            VStack {
                TextField("Enter with Room ID ...",
                          text: $inputText,
                          onCommit: {
                    Task {
                        let (room, currentUserId) = await fetchRoomInfo()
                        NavigationLink(
                            destination: CardListView(room: room,
                                                      currentUserId: currentUserId)) {}
                    }
                })
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.Neumorphic.main)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 20),
                                         darkShadow: Color.Neumorphic.darkShadow,
                                         lightShadow: Color.Neumorphic.lightShadow,
                                         spread: 0.2,
                                         radius: 2)
                )
            }
            .padding(.all, 40)
        }
        .navigationTitle("Scrum Dinger")
    }
    
    // MARK: - Private
    
    /// 入力テキスト
    @State private var inputText = ""
    
    private var roomDataStore = RoomDataStore()
    
    /// ルームを取得し、ルームとカレントユーザーIDを返却
    private func fetchRoomInfo() async -> (Room, String) {
        let room: Room
        let roomId: String
        let currentUserId = String(Int.random(in: 1000..<9999))
        let userIdList: [String]
        
        let roomExist = await roomDataStore.checkRoomExist(roomId: inputText)
        if roomExist {
            // 既存のルーム
            room = await roomDataStore.fetchRoom(roomId: inputText)!
            roomId = room.id
            userIdList = room.userIdList + [currentUserId]
            
            await roomDataStore.addUserToRoom(roomId: roomId, userId: currentUserId)
        } else {
            // 新規ルーム
            roomId = String(Int.random(in: 1000..<9999))
            userIdList = [currentUserId]
            room = Room(id: roomId,
                        userIdList: userIdList,
                        cardPackage: CardPackage.sampleCardPackage)
            
            await roomDataStore.createRoom(room)
        }
        
        return (room, currentUserId)
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
