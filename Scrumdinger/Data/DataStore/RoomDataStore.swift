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
            id: roomId,
            createdAt: Timestamp()
        ])
        
        // ユーザー追加
        room.userList.forEach { user in
            let userId = user.id
            let userDocument = roomDocument.collection(users).document(userId)
            userDocument.setData([
                id: userId,
                name: user.name,
                selectedCardId: user.selectedCardId,
                createdAt: Timestamp()
            ])
        }
        
        // カードパッケージ追加
        let cardPackageId = room.cardPackage.id
        let cardPackageDocument = roomDocument.collection(cardPackages).document(cardPackageId)
        try? await cardPackageDocument.setData([
            id: cardPackageId,
            themeColor: room.cardPackage.themeColor.rawValue,
            createdAt: Timestamp()
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
        let roomSnapshot = await firebaseRef?.roomSnapshot()
        let roomData = roomSnapshot?.data()
        let roomId = roomData![id] as! Int
        
        // ユーザー一覧取得
        let usersSnapshot = await firebaseRef?.usersSnapshot()
        let userList: [User] = usersSnapshot!.map { userDoc in
            let userData = userDoc.data()
            return User(id: userData[id] as! String,
                        name: userData[name] as! String,
                        selectedCardId: userData[selectedCardId] as! String)
        }
        
        // カードパッケージ取得
        let cardPackagesSnapshot = await firebaseRef?.cardPackagesSnapshot()?.first
        let cardPackageData = cardPackagesSnapshot?.data()
        let cardPackageId = cardPackageData![id] as! String
        let themeColor = cardPackageData![themeColor] as! ThemeColor
        
        // カード一覧取得
        let cardsSnapshot = await firebaseRef?.cardsSnapshot(cardPackageId: cardPackageId)
        let cardList: [Card] = cardsSnapshot!.map { cardDoc in
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
    
//    func deleteRoom() async {
//        try? await firebaseRef?.roomDocument.delete()
//    }
    
    func subscribeUser() {
        userListener = firebaseRef?.usersQuery.addSnapshotListener { querySnapshot, error in
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    // TODO: delegateで処理を委譲する
                }
                if (diff.type == .modified) {
                    
                }
                if (diff.type == .removed) {
                    
                }
            }
        }
    }
    
    func unsubscribeUser() {
        userListener?.remove()
    }
    
    // MARK: - Private
        
    private var firebaseRef: FirebaseRef?
    
    private var userListener: ListenerRegistration?
    
    private let id = "id"
    
    private let createdAt = "createdAt"
    
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
