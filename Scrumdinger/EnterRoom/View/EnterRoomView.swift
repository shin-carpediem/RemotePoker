import Neumorphic
import SwiftUI

struct EnterRoomView: View {
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()

            VStack {
                TextField("Enter with Room ID ...",
                          value: $inputNumber,
                          format: .number)
                .onSubmit {
                    Task {
                        if let (room, currentUserId) = await fetchRoomInfo() {
                            NavigationLink(
                                destination: CardListView(room: room,
                                                          currentUserId: currentUserId)) {}
                        }
                    }
                }
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
        .alert("4 Digit Number Required",
               isPresented: $isShownInputInvalidAlert,
               actions: {
        }, message: {
            Text("If the number is new, a new room will be created.")
        })
        .navigationTitle("Scrum Dinger")
    }
    
    // MARK: - Private
    
    /// 入力ナンバー
    @State private var inputNumber = 1000
    
    /// 入力したIDが無効だと示すアラートを表示するか
    @State private var isShownInputInvalidAlert = false
    
    private var roomDataStore = RoomDataStore()
    
    private var isInputNumberValid: Bool {
        String(inputNumber).count == 4
    }
    
    /// ルームを取得し、ルームとカレントユーザーIDを返却
    private func fetchRoomInfo() async -> (Room, String)? {
        let room: Room
        let roomId: Int
        let currentUserId = UUID().uuidString
        let userIdList: [String]
        
        if !isInputNumberValid {
            isShownInputInvalidAlert = true
            return nil
        }
        
        let roomExist = await roomDataStore.checkRoomExist(roomId: inputNumber)
        if roomExist {
            // 既存のルーム
            room = await roomDataStore.fetchRoom(roomId: inputNumber)!
            roomId = room.id
            userIdList = room.userIdList + [currentUserId]
            
            await roomDataStore.addUserToRoom(roomId: roomId, userId: currentUserId)
        } else {
            // 新規ルーム
            roomId = inputNumber
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
