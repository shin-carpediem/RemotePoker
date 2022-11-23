import Foundation

class EnterRoomPresenter {
    /// ルーム
    var room: Room?
    
    /// カレントユーザーID
    let currentUserId = UUID().uuidString
    
    func fetchRoomInfo(inputNumber: Int) async {
        let roomExist = await dataStore.checkRoomExist(roomId: inputNumber)
        if roomExist {
            // 既存ルーム
            room = await dataStore.fetchRoom(roomId: inputNumber)
            let roomId = room!.id
            let userIdList = room!.userIdList + [currentUserId]
            
            await dataStore.addUserToRoom(roomId: roomId, userId: currentUserId)
        } else {
            // 新規ルーム
            room = Room(id: inputNumber,
                        userIdList: [currentUserId],
                        cardPackage: .sampleCardPackage)
            
            await dataStore.createRoom(room!)
        }
    }
    
    // MARK: - Private
    
    private var dataStore = RoomDataStore()
}
