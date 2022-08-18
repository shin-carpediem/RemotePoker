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
            "usersId": usersId
        ]) { error in
            print("Error writing document: \(String(describing: error))")
        }
        let cardListSubCollection = roomCollection.document(id).collection("cardList")
        cardList.forEach {
            let cardListId = $0.id
            cardListSubCollection.document(cardListId).setData([
                "id": cardListId,
                // TODO: SwiftUIのColorは型でもないしFirestoreで保存できるデータではない
//                "color": $0.color
            ])
            $0.numberSet.forEach {
                let eachCardId = $0.id
                cardListSubCollection.document(cardListId).collection("numberSet").document(eachCardId).setData([
                    "id": eachCardId,
                    "number": $0.number
                ])
            }
        }
    }
    
    func addUserToRoom(_ userId: String) {
        usersId.append(userId)
        roomCollection.document(id).updateData([
            "usersId": usersId
        ]) { error in
            print("Error writing document: \(String(describing: error))")
        }
    }
    
    func removeUserFromRoom(_ userId: String) {
        usersId.removeAll(where: {$0 == userId})
        roomCollection.document(id).updateData([
            "usersId": usersId
        ]) { error in
            print("Error writing document: \(String(describing: error))")
        }
    }
    
    // MARK: - Private
    
    private let roomCollection = Firestore.firestore().collection("rooms")
}

extension RoomModel {
    static let sampleData: RoomModel = RoomModel()
}
