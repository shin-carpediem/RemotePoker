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
                "createdAt": Timestamp()
            ])
            
            let selectedCardDocument = userDocument.collection("selectedCards").document(userId)
            selectedCardDocument.setData([
                "id": "",
                "point": "",
                "index": 0,
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
        let roomSnapshot = await firebaseRef?.roomSnapshot()
        let roomData = roomSnapshot?.data()
        let roomId = roomData!["id"] as! Int
        
        // ユーザー一覧取得
        let usersSnapshot = await firebaseRef?.usersSnapshot()
        let userList: [User] = usersSnapshot!.map { userDoc in
            let userData = userDoc.data()
            return User(id: userData["id"] as! String,
                        name: userData["name"] as! String,
                        // TODO: これではダメ
                        selectedCard: nil)
        }
        
        // カードパッケージ取得
        let cardPackagesSnapshot = await firebaseRef?.cardPackagesSnapshot()?.first
        let cardPackageData = cardPackagesSnapshot?.data()
        let cardPackageId = cardPackageData!["id"] as! String
        let themeColor = cardPackageData!["themeColor"] as! String
        
        // カード一覧取得
        let cardsSnapshot = await firebaseRef?.cardsSnapshot(cardPackageId: cardPackageId)
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
        let usersCollection = firebaseRef?.usersCollection
        usersCollection?.addDocument(data: [
            "id": user.id,
            "name": user.name
        ]) { _ in () }

        let selectedCardsCollection = firebaseRef?.selectedCardsCollection(userId: user.id)
        selectedCardsCollection?.addDocument(data: [
            "id": "",
            "point": "",
            "index": 0
        ]) { _ in () }
    }
    
    func removeUserFromRoom(userId: String) async {
        try? await firebaseRef?.userDocument(userId: userId).delete()
    }
    
//    func deleteRoom() async {
//        try? await firebaseRef?.roomDocument.delete()
//    }
    
    func fetchUserName(id: String) -> String {
        var userName = ""
        let userDocument = firebaseRef?.userDocument(userId: id)
        userDocument?.getDocument() { userSnapshot, _ in
            let userData = userSnapshot?.data()
            userName = userData?["name"] as! String
        }
        return userName
    }
    
    func subscribeUser() {
        userListener = firebaseRef?.usersQuery.addSnapshotListener { querySnapshot, error in
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
    
    func updateSelectedCard(userId: String, selectedCard: Card) async {
        let selectedCardDocument = firebaseRef?.selectedCardDocument(userId: userId)
        try? await selectedCardDocument?.updateData([
            "id": selectedCard.id,
            "point": selectedCard.point,
            "index": selectedCard.index
        ])
    }
    
    func removeSelectedCardFromAllUsers() async {
        // TODO: 要実装
        
    }
    
    func unsubscribeUser() {
        userListener?.remove()
    }
    
    // MARK: - Private
        
    private var firebaseRef: FirebaseRef?
    
    private var delegate: RoomDelegate?
    
    private var userListener: ListenerRegistration?
}
