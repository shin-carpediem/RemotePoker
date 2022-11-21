import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class RoomDataStore: RoomRepository {
    func createRoom(_ room: RoomModel) {
        let roomId = room.id
        let document = Firestore.firestore().collection("rooms").document(roomId)
        document.setData([
            "id": roomId,
            "userIdList": room.userIdList
        ])
        
        let cardList = document.collection("cardList")
        room.cardList.forEach { card in
            let cardListId = card.id
            cardList.document(cardListId).setData([
                "id": cardListId,
                // TODO: SwiftUIのColorは型でもないしFirestoreで保存できるデータではない
//                "color": card.color
            ])
            
            card.cardList.forEach { card in
                let eachCardId = card.id
                let document = cardList.document(cardListId).collection("pointList").document(eachCardId)
                document.setData([
                    "id": eachCardId,
                    "point": card.point
                ])
            }
        }
    }
    
    func checkRoomExist(roomId: String) async -> Bool {
        let snapshot = try? await Firestore.firestore().collection("rooms").whereField("id", isEqualTo: roomId).getDocuments()
        guard let snapshot else { return false }
        let documents = snapshot.documents

        return !documents.isEmpty
    }
    
    func fetchRoom(roomId: String) async -> RoomModel? {
        let snapshot = try? await Firestore.firestore().collection("rooms").whereField("id", isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return nil }
        let room = RoomModel(id: data["id"] as! String,
                             userIdList: data["userIdList"] as! [String])

        return room
    }
    
    func addUserToRoom(roomId: String, userId: String) async {
        let snapshot = try? await Firestore.firestore().collection("rooms").whereField("id", isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return }
        var userIdList = data["userIdList"] as! [String]
        userIdList.append(userId)
        
        let room = Firestore.firestore().collection("rooms").document(roomId)
        try? await room.updateData([
            "userIdList": userIdList
        ])
    }
    
    func removeUserFromRoom(roomId: String, userId: String) async {
        let snapshot = try? await Firestore.firestore().collection("rooms").whereField("id", isEqualTo: roomId).getDocuments()
        let document = snapshot?.documents.first
        let data = document.map { $0.data() }
        guard let data else { return }
        var userIdList = data["userIdList"] as! [String]
        userIdList.removeAll(where: { $0 == userId })
        
        let room = Firestore.firestore().collection("rooms").document(roomId)
        try? await room.updateData([
            "userIdList": userIdList
        ])
    }
    
    func deleteRoom(roomId: String) {
        let document = Firestore.firestore().collection("rooms").document(roomId)
        document.delete()
    }
}
