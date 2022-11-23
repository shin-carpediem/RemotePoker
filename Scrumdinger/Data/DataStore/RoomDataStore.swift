import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class RoomDataStore: RoomRepository {
    func createRoom(_ room: Room) async {
        let roomId = room.id
        let roomDocument = Firestore.firestore().collection(roomCollection).document(roomId)
        try? await roomDocument.setData([
            id: roomId,
            userIdList: room.userIdList
        ])
        
        let cardPackageId = room.cardPackage.id
        let cardPackageDocument = roomDocument.collection(cardPackagesCollection).document(cardPackageId)
        try? await cardPackageDocument.setData([
            id: cardPackageId,
            // TODO: SwiftUIのColorは型でもないしFirestoreで保存できるデータではない
//            themeColor: room.cardPackage.themeColor
        ])
        
        room.cardPackage.cardList.forEach { card in
            let cardId = card.id
            let cardDocument = cardPackageDocument.collection(cardCollection).document(cardId)
            cardDocument.setData([
                id: cardId,
                point: card.point
            ])
        }
    }
    
    func checkRoomExist(roomId: String) async -> Bool {
        let snapshot = try? await Firestore.firestore().collection(roomCollection).whereField(id, isEqualTo: roomId).getDocuments()
        guard let snapshot else { return false }
        let documents = snapshot.documents

        return !documents.isEmpty
    }
    
    func fetchRoom(roomId: String) async -> Room? {
        let snapshot = try? await Firestore.firestore().collection(roomCollection).whereField(id, isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return nil }
        let room = Room(id: data[id] as! String,
                        userIdList: data[userIdList] as! [String],
                        // TODO: サンプルデータ
                        cardPackage: CardPackage.sampleCardPackage)

        return room
    }
    
    func addUserToRoom(roomId: String, userId: String) async {
        let snapshot = try? await Firestore.firestore().collection(roomCollection).whereField(id, isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return }
        var list = data[userIdList] as! [String]
        list.append(userId)
        
        let room = Firestore.firestore().collection(roomCollection).document(roomId)
        try? await room.updateData([
            userIdList: list
        ])
    }
    
    func removeUserFromRoom(roomId: String, userId: String) async {
        let snapshot = try? await Firestore.firestore().collection(roomCollection).whereField(id, isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return }
        var list = data[userIdList] as! [String]
        list.removeAll(where: { $0 == userId })
        
        let room = Firestore.firestore().collection(roomCollection).document(roomId)
        try? await room.updateData([
            userIdList: list
        ])
    }
    
    func deleteRoom(roomId: String) async {
        let document = Firestore.firestore().collection(roomCollection).document(roomId)
        try? await document.delete()
    }
    
    // MARK: - Private
    
    private let roomCollection = "rooms"
    
    private let cardPackagesCollection = "cardPackages"
    
    private let cardCollection = "cards"
    
    private let id = "id"
    
    private let userIdList = "userIdList"
    
    private let themeColor = "themeColor"
    
    private let point = "point"
}
