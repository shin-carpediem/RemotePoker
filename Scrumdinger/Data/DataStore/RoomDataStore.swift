import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class RoomDataStore: RoomRepository {
    init() {
        firebaseRef = nil
    }
    
    convenience init(roomId: Int) {
        self.init()
        firebaseRef = FirebaseRef(roomId: roomId)
    }
    
    func createRoom(_ room: Room) async {
        // ルーム追加
        let roomId = room.id
        let roomDocument = Firestore.firestore().collection(rooms).document(String(roomId))
        try? await roomDocument.setData([
            id: roomId
        ])
        
        // ユーザー追加
        room.userList.forEach { user in
            let userId = user.id
            let userDocument = roomDocument.collection(users).document(userId)
            userDocument.setData([
                id: userId,
                name: user.name,
                selectedCardId: user.selectedCardId
            ])
        }
        
        // カードパッケージ追加
        let cardPackageId = room.cardPackage.id
        let cardPackageDocument = roomDocument.collection(cardPackages).document(cardPackageId)
        try? await cardPackageDocument.setData([
            id: cardPackageId,
            themeColor: room.cardPackage.themeColor.rawValue
        ])
        
        // カード一覧追加
        room.cardPackage.cardList.forEach { card in
            let cardId = card.id
            let cardDocument = cardPackageDocument.collection(cards).document(cardId)
            cardDocument.setData([
                id: cardId,
                point: card.point,
                index: card.index
            ])
        }
    }
    
    func checkRoomExist(roomId: Int) async -> Bool {
        guard let document = try? await Firestore.firestore().collection(rooms).document(String(roomId)).getDocument() else { return false }
        return document.exists
    }
    
    func fetchRoom() async -> Room {
        // ルーム取得
        let roomDocument = try? await firebaseRef?.roomDocument.getDocument()
        let roomData = roomDocument?.data()
        let roomId = roomData![id] as! Int
        
        // ユーザー一覧取得
        let usersDocument = await firebaseRef?.usersDocument()?.documents
        let userList: [User] = usersDocument!.map { userDoc in
            let userData = userDoc.data()
            return User(id: userData[id] as! String,
                        name: userData[name] as! String,
                        selectedCardId: userData[selectedCardId] as! String)
        }
        
        // カードパッケージ取得
        let cardPackagesDocument = await firebaseRef?.cardPackagesDocument()?.documents.first
        let cardPackageData = cardPackagesDocument?.data()
        let cardPackageId = cardPackageData![id] as! String
        let themeColor = cardPackageData![themeColor] as! ThemeColor
        
        // カード一覧取得
        let cardsDocument = await firebaseRef?.cardsDocument(cardPackageId: cardPackageId)?.documents
        let cardList: [Card] = cardsDocument!.map { cardDoc in
            let cardData = cardDoc.data()
            return Card(id: cardData[id] as! String,
                        point: cardData[point] as! String,
                        index: cardData[index] as! Int)
        }
        
        let cardPackage = CardPackage(id: cardPackageId,
                                      themeColor: themeColor,
                                      cardList: cardList)

        let room = Room(id: roomId,
                        userList: userList,
                        cardPackage: cardPackage)

        return room
    }
    
    func addUserToRoom(user: User) async {
        let usersCollection = firebaseRef?.usersCollection
        usersCollection?.addDocument(data: [
            id: user.id,
            name: user.name,
            selectedCardId: user.selectedCardId
        ]) { error in
            ()
        }
    }
    
    func removeUserFromRoom(userId: String) async {
        try? await firebaseRef?.userDocument(userId: userId).delete()
    }
    
    func deleteRoom() async {
        try? await firebaseRef?.roomDocument.delete()
    }
    
    // MARK: - Private
    
    private var firebaseRef: FirebaseRef?
    
    private let id = "id"
    
    private let rooms = "rooms"
    
    private let users = "users"
    
    private let name = "name"
    
    private let selectedCardId = "selectedCardId"
    
    private let cardPackages = "cardPackages"
    
    private let cards = "cards"
    
    private let userIdList = "userIdList"
    
    private let cardPackage = "cardPackage"
    
    private let themeColor = "themeColor"
    
    private let point = "point"
    
    private let index = "index"
}
