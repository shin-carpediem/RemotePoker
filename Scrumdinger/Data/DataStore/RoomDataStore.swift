import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class RoomDataStore: RoomRepository {
    init() {}
    
    convenience init(roomId: Int) {
        self.init()
        firestoreRef = FirestoreRef(roomId: roomId)
    }
    
    // MARK: - RoomRepository
    
    weak var delegate: RoomDelegate?
    
    func checkRoomExist(roomId: Int) async -> Bool {
        guard let document = try? await Firestore.firestore().collection("rooms").document(String(roomId)).getDocument() else { return false }
        return document.exists
    }
    
    func createRoom(_ room: Room) async {
        // ルーム追加
        let roomId = room.id
        let roomDocument = Firestore.firestore().collection("rooms").document(String(roomId))
        try? await roomDocument.setData([
            "id": roomId,
            "createdAt": Timestamp()
        ])
        
        // ユーザー追加
        room.userList.forEach { user in
            let userId = user.id
            let userDocument = roomDocument.collection("users").document(userId)
            userDocument.setData([
                "id": userId,
                "name": user.name,
                "selectedCardId": user.selectedCardId,
                "createdAt": Timestamp()
            ])
        }
        
        // カードパッケージ追加
        let cardPackageId = room.cardPackage.id
        let cardPackageDocument = roomDocument.collection("cardPackages").document(cardPackageId)
        try? await cardPackageDocument.setData([
            "id": cardPackageId,
            "themeColor": room.cardPackage.themeColor.rawValue,
            "createdAt": Timestamp()
        ])
        
        // カード一覧追加
        room.cardPackage.cardList.forEach { card in
            let cardId = card.id
            let cardDocument = cardPackageDocument.collection("cards").document(cardId)
            cardDocument.setData([
                "id": cardId,
                "point": card.point,
                "index": card.index
            ])
        }
    }
    
    func fetchRoom() async -> Room {
        // ルーム取得
        let roomSnapshot = await firestoreRef?.roomSnapshot()
        let roomData = roomSnapshot?.data()
        let roomId = roomData!["id"] as! Int
        
        // ユーザー一覧取得
        let usersSnapshot = await firestoreRef?.usersSnapshot()
        let userList: [User] = usersSnapshot!.map { userDoc in
            let userData = userDoc.data()
            return User(id: userData["id"] as! String,
                        name: userData["name"] as! String,
                        selectedCardId: userData["selectedCardId"] as! String)
        }
        
        // カードパッケージ取得
        let cardPackagesSnapshot = await firestoreRef?.cardPackagesSnapshot()?.first
        let cardPackageData = cardPackagesSnapshot?.data()
        let cardPackageId = cardPackageData!["id"] as! String
        let themeColor = cardPackageData!["themeColor"] as! String
        
        // カード一覧取得
        let cardsSnapshot = await firestoreRef?.cardsSnapshot(cardPackageId: cardPackageId)
        let cardList: [Card] = cardsSnapshot!.map { cardDoc in
            let cardData = cardDoc.data()
            return Card(id: cardData["id"] as! String,
                        point: cardData["point"] as! String,
                        index: cardData["index"] as! Int)
        }.sorted { $0.index < $1.index }
        
        let cardPackage = CardPackage(id: cardPackageId,
                                      themeColor: ThemeColor(rawValue: themeColor)!,
                                      cardList: cardList)

        let room = Room(id: roomId,
                        userList: userList,
                        cardPackage: cardPackage)

        return room
    }
    
    func addUserToRoom(user: User) async {
        let userDocument = firestoreRef?.usersCollection.document(user.id)
        try? await userDocument?.setData([
            "id": user.id,
            "name": user.name,
            "selectedCardId": user.selectedCardId
        ])
    }
    
    func removeUserFromRoom(userId: String) async {
        try? await firestoreRef?.userDocument(userId: userId).delete()
    }
    
//    func deleteRoom() async {
//        try? await firebaseRef?.roomDocument.delete()
//    }
    
    func subscribeCardPackage() {
        cardPackagesListener = firestoreRef?.cardPackagesQuery.addSnapshotListener { querySnapshot, error in
            querySnapshot?.documentChanges.forEach { [weak self] diff in
                var actionType: CardPackageActionType
                if (diff.type == .added) {
                    actionType = .added
                } else if (diff.type == .modified) {
                    actionType = .modified
                } else if (diff.type == .removed) {
                    actionType = .removed
                } else {
                    actionType = .unKnown
                }
                
                self?.delegate?.whenCardPackageChanged(actionType: actionType)
            }
        }
    }
    
    func unsubscribeCardPackage() {
        cardPackagesListener?.remove()
    }
    
    func subscribeUser() {
        usersListener = firestoreRef?.usersQuery.addSnapshotListener { querySnapshot, error in
            querySnapshot?.documentChanges.forEach { [weak self] diff in
                var actionType: UserActionType
                if (diff.type == .added) {
                    actionType = .added
                } else if (diff.type == .modified) {
                    actionType = .modified
                } else if (diff.type == .removed) {
                    actionType = .removed
                } else {
                    actionType = .unKnown
                }
                
                self?.delegate?.whenUserChanged(actionType: actionType)
            }
        }
    }
    
    func fetchUser(id: String) -> User {
        var user: User = .init(id: "", name: "", selectedCardId: "")
        let userDocument = firestoreRef?.userDocument(userId: id)
        userDocument?.getDocument() { userSnapshot, _ in
            let userData = userSnapshot?.data()
            user = .init(id: userData?["id"] as! String,
                         name: userData?["name"] as! String,
                         selectedCardId: userData?["selectedCardId"] as! String)
        }
        return user
    }
    
    func unsubscribeUser() {
        usersListener?.remove()
    }
    
    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        selectedCardDictionary.forEach { userId, selectedCardId in
            let userDocument = firestoreRef?.userDocument(userId: userId)
            userDocument?.updateData([
                "selectedCardId": selectedCardId
            ])
        }
    }
    
    func updateThemeColor(cardPackageId: String,
                          themeColor: ThemeColor) {
        let cardPackageDocument = firestoreRef?.cardPackageDocument(cardPackageId: cardPackageId)
        cardPackageDocument?.updateData([
            "themeColor": themeColor.rawValue
        ])
    }
    
    // MARK: - Private
        
    private var firestoreRef: FirestoreRef?
    
    private var cardPackagesListener: ListenerRegistration?
    
    private var usersListener: ListenerRegistration?
}
