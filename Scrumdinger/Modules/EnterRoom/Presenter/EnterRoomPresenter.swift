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
                                  name: "")
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - EnterRoomPresentation
    
    func fetchRoomInfo(inputName: String, inputRoomId: Int) async {
        let roomExist = await dependency.dataStore.checkRoomExist(roomId: inputRoomId)
        if roomExist {
            // 既存ルーム
            dependency.dataStore = RoomDataStore(roomId: inputRoomId)
            room = await dependency.dataStore.fetchRoom()
            await dependency.dataStore.addUserToRoom(user: .init(
                id: currentUser.id,
                name: inputName))
            room?.userList.append(currentUser)
        } else {
            // 新規ルーム
            room = Room(id: inputRoomId,
                        userList: [.init(
                            id: currentUser.id,
                            name: inputName)],
                        cardPackage: .sampleCardPackage)
            await dependency.dataStore.createRoom(room!)
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
}
