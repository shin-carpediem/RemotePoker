import FirebaseFirestore
import FirebaseFirestoreSwift

class RoomModel: Identifiable {
    let id = String(Int.random(in: 1000..<9999))
    
    private(set) var usersId: [String] = []
    private(set) var cardList = [EstimateNumberSetModel.sampleData]
    
    // MARK: - Method
    
    func createRoom() {
        roomCollection.document(id).setData([
            "id": id,
            "usersId": usersId,
            "cardList": cardList
        ])
    }
    
    func addUserToRoom(_ userId: String) {
        usersId.append(userId)
        roomCollection.document().updateData([
            "usersId": usersId
        ])
    }
    
    func removeUserFromRoom(_ userId: String) {
        usersId.removeAll(where: {$0 == userId})
        roomCollection.document().updateData([
            "usersId": userId
        ])
    }
    
    // MARK: - Private
    
    private let roomCollection = Firestore.firestore().collection("rooms")
}

extension RoomModel {
    static let sampleData: RoomModel = RoomModel()
}
