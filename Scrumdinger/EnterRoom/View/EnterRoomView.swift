import Neumorphic
import SwiftUI

struct EnterRoomView: View {
    init() {}
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            VStack {
                TextField("Enter with Room ID ...",
                          text: $inputText,
                          onCommit: {
                    Task {
                        let room = await fetchRoomInfo()!
                        NavigationLink(
                            destination: CardListView(roomId: room.id,
                                                      userIdList: room.userIdList)) {}
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
    
    private func fetchRoomInfo() async -> RoomModel? {
        let roomId: String
        let userId = String(Int.random(in: 1000..<9999))
        let userIdList: [String]
        
        let roomExist = await roomDataStore.checkRoomExist(roomId: inputText)
        if roomExist {
            // 既存のルーム
            guard let room = await roomDataStore.fetchRoom(roomId: inputText) else { return nil }
            roomId = room.id
            userIdList = room.userIdList + [userId]
        } else {
            // 新規ルーム
            roomId = String(Int.random(in: 1000..<9999))
            userIdList = [userId]
        }
        
        return RoomModel(id: roomId,
                         userIdList: userIdList)
    }
}

// MARK: - Preview

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView()
    }
}
