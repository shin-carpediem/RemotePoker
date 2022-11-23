import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class RoomDataStore: RoomRepository {
    func createRoom(_ room: Room) async {
        let roomId = room.id
        let roomDocument = Firestore.firestore().collection(rooms).document(String(roomId))
        try? await roomDocument.setData([
            id: roomId,
            userIdList: room.userIdList
        ])
        
        let cardPackageId = room.cardPackage.id
        let cardPackageDocument = roomDocument.collection(cardPackages).document(cardPackageId)
        try? await cardPackageDocument.setData([
            id: cardPackageId,
            themeColor: room.cardPackage.themeColor.rawValue
        ])
        
        room.cardPackage.cardList.forEach { card in
            let cardId = card.id
            let cardDocument = cardPackageDocument.collection(cards).document(cardId)
            cardDocument.setData([
                id: cardId,
                point: card.point
            ])
        }
    }
    
    func checkRoomExist(roomId: Int) async -> Bool {
        let snapshot = try? await Firestore.firestore().collection(rooms).whereField(id, isEqualTo: roomId).getDocuments()
        guard let snapshot else { return false }
        let documents = snapshot.documents

        return !documents.isEmpty
    }
    
    func fetchRoom(roomId: Int) async -> Room? {
        let snapshot = try? await Firestore.firestore().collection(rooms).whereField(id, isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return nil }
        let room = Room(id: data[id] as! Int,
                        userIdList: data[userIdList] as! [String],
                        cardPackage: data[cardPackage] as! CardPackage)

        return room
    }
    
    func addUserToRoom(roomId: Int, userId: String) async {
        let snapshot = try? await Firestore.firestore().collection(rooms).whereField(id, isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return }
        var list = data[userIdList] as! [String]
        list.append(userId)
        
        let room = Firestore.firestore().collection(rooms).document(String(roomId))
        try? await room.updateData([
            userIdList: list
        ])
    }
    
    func removeUserFromRoom(roomId: Int, userId: String) async {
        let snapshot = try? await Firestore.firestore().collection(rooms).whereField(id, isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return }
        var list = data[userIdList] as! [String]
        list.removeAll(where: { $0 == userId })
        
        let room = Firestore.firestore().collection(rooms).document(String(roomId))
        try? await room.updateData([
            userIdList: list
        ])
    }
    
    func deleteRoom(roomId: Int) async {
        let document = Firestore.firestore().collection(rooms).document(String(roomId))
        try? await document.delete()
    }
    
    // MARK: - Private
    
    private let rooms = "rooms"
    
    private let cardPackages = "cardPackages"
    
    private let cards = "cards"
    
    private let id = "id"
    
    private let userIdList = "userIdList"
    
    private let cardPackage = "cardPackage"
    
    private let themeColor = "themeColor"
    
    private let point = "point"
}
