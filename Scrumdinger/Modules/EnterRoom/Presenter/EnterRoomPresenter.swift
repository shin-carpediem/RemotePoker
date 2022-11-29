import Foundation

class EnterRoomPresenter: EnterRoomPresentation {
    // MARK: - Dependency
    
    struct Dependency {
        var dataStore: RoomDataStore
    }
    
    /// ルーム
    var room: Room?
    
    /// カレントユーザー
    var currentUser: User = .init(id: UUID().uuidString,
                                  name: "",
                                  selectedCardId: "")
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - EnterRoomPresentation
    
    func enterRoom(userName: String, roomId: Int) async {
        let roomExist = await dependency.dataStore.checkRoomExist(roomId: roomId)
        if roomExist {
            // 既存ルーム
            dependency.dataStore = RoomDataStore(roomId: roomId)
            room = await dependency.dataStore.fetchRoom()
            await dependency.dataStore.addUserToRoom(user: .init(
                id: currentUser.id,
                name: userName,
                selectedCardId: ""))
            room?.userList.append(currentUser)
        } else {
            // 新規ルーム
            room = Room(id: roomId,
                        userList: [.init(
                            id: currentUser.id,
                            name: userName,
                            selectedCardId: "")],
                        cardPackage: .sampleCardPackage)
            await dependency.dataStore.createRoom(room!)
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}
