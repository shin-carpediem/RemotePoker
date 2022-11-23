import Foundation

class EnterRoomPresenter {
    /// ルーム
    var room: Room?
    
    /// カレントユーザーID
    let currentUserId = UUID().uuidString
    
    func fetchRoomInfo(inputNumber: Int) async {
        let roomId: Int
        let userIdList: [String]
        
        let roomExist = await dataStore.checkRoomExist(roomId: inputNumber)
        if roomExist {
            // 既存ルーム
            room = await dataStore.fetchRoom(roomId: inputNumber)
            roomId = room!.id
            userIdList = room!.userIdList + [currentUserId]
            
            await dataStore.addUserToRoom(roomId: roomId, userId: currentUserId)
        } else {
            // 新規ルーム
            roomId = inputNumber
            userIdList = [currentUserId]
            room = Room(id: roomId,
                        userIdList: userIdList,
                        cardPackage: CardPackage.sampleCardPackage)
            
            await dataStore.createRoom(room!)
        }
    }
    
    // MARK: - Private
    
    private var dataStore = RoomDataStore()
}
