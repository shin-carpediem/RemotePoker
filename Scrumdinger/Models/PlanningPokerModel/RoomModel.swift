import FirebaseFirestore
import FirebaseFirestoreSwift

class RoomModel: Identifiable {
    let id = String(Int.random(in: 1000..<9999))
    var usersId: [UUID] = []
    var cardList = [EstimateNumberSetModel.sampleData]
    
    let firebaseFirestore = Firestore.firestore()
    lazy var roomDocument = firebaseFirestore.collection("rooms").document(id)
    
    // MARK: - Method
    
    func createRoom() {
        roomDocument.setData([
            "id": id,
            "usersId": usersId,
            "cardList": cardList
        ])
    }
    
    func addUserToRoom(_ userId: UUID) {
        usersId.append(userId)
        roomDocument.updateData([
            "usersId": usersId
        ])
    }
    
    func removeUserFromRoom(_ userId: UUID) {
        usersId.removeAll(where: {$0 == userId})
        roomDocument.updateData([
            "usersId": userId
        ])
    }
}

extension RoomModel {
    static let sampleData: RoomModel = RoomModel()
}
