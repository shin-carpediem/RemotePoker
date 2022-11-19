import FirebaseFirestore
import FirebaseFirestoreSwift

class RoomModel: Identifiable {
    /// ID
    let id = String(Int.random(in: 1000..<9999))
    
    /// ユーザーID一覧
    var userIdList: [String] = []

    /// カード一覧
    private(set) var cardList = [CardListModel.sampleData]

    func createRoom() {
        existingRoomList.document(id).setData([
            "id": id,
            "userIdList": userIdList
        ])
        let cardListSubCollection = existingRoomList.document(id).collection("cardList")
        cardList.forEach {
            let cardListId = $0.id
            cardListSubCollection.document(cardListId).setData([
                "id": cardListId,
                // TODO: SwiftUIのColorは型でもないしFirestoreで保存できるデータではない
//                "color": $0.color
            ])
            $0.pointList.forEach {
                let eachCardId = $0.id
                cardListSubCollection.document(cardListId).collection("pointList").document(eachCardId).setData([
                    "id": eachCardId,
                    "point": $0.point
                ])
            }
        }
    }
    
    func deleteRoom(roomId: String) {
        existingRoomList.document(roomId).delete()
    }
    
    func addUserToRoom(roomId: String, userId: String, userIdList: inout [String]) {
        userIdList.append(userId)
        existingRoomList.document(roomId).updateData([
            "userIdList": userIdList
        ])
    }
    
    func removeUserFromRoom(roomId: String, userId: String, userIdList: inout [String]) {
        userIdList.removeAll(where: {$0 == userId})
        if userIdList.isEmpty {
            deleteRoom(roomId: roomId)
        }
        existingRoomList.document(roomId).updateData([
            "userIdList": userIdList
        ])
    }
    
    // MARK: - Private
    
    /// 既存のルーム一覧
    private let existingRoomList = Firestore.firestore().collection("rooms")
}

extension RoomModel {
    static let sampleData = RoomModel()
}
