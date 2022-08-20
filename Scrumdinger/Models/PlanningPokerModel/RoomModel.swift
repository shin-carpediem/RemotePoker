import FirebaseFirestore
import FirebaseFirestoreSwift

class RoomModel: Identifiable {
    let id = String(Int.random(in: 1000..<9999))
    
    var usersId: [String] = []
    private(set) var cardList = [EstimateNumberSetModel.sampleData]
    
    // MARK: - Method
    
    func createRoom() {
        roomCollection.document(id).setData([
            "id": id,
            "usersId": usersId
        ])
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
    
    func deleteRoom(roomId: String) {
        roomCollection.document(roomId).delete()
    }
    
    func addUserToRoom(roomId: String, userId: String, usersIdList: inout [String]) {
        usersIdList.append(userId)
        roomCollection.document(roomId).updateData([
            "usersId": usersIdList
        ])
    }
    
    func removeUserFromRoom(roomId: String, userId: String, usersIdList: inout [String]) {
        usersIdList.removeAll(where: {$0 == userId})
        if usersIdList.isEmpty {
            deleteRoom(roomId: roomId)
        }
        roomCollection.document(roomId).updateData([
            "usersId": usersIdList
        ])
    }
    
    // MARK: - Private
    
    private let roomCollection = Firestore.firestore().collection("rooms")
}

extension RoomModel {
    static let sampleData: RoomModel = RoomModel()
}
