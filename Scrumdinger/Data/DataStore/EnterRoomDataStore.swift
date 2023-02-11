import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class EnterRoomDataStore: EnterRoomRepository {
    // MARK: - EnterRoomRepository

    func checkRoomExist(roomId: Int) async -> Bool {
        let roomDocument = Firestore.firestore().collection("rooms").document(String(roomId))
        guard let document = try? await roomDocument.getDocument() else { return false }
        return document.exists
    }

    func createRoom(_ room: RoomEntity) async -> Result<Void, FirebaseError> {
        do {
            // ルーム追加
            let roomId = room.id
            let roomDocument = Firestore.firestore().collection("rooms").document(String(roomId))
            try await roomDocument.setData([
                "id": roomId,
                "createdAt": Timestamp(),
                "updatedAt": Date(),
            ])

            // ユーザー追加
            room.userList.forEach { user in
                let userId = user.id
                let userDocument = roomDocument.collection("users").document(userId)
                userDocument.setData([
                    "id": userId,
                    "name": user.name,
                    "currentRoomId": roomId,
                    "selectedCardId": user.selectedCardId,
                    "createdAt": Timestamp(),
                    "updatedAt": Date(),
                ])
            }

            // カードパッケージ追加
            let cardPackageId = room.cardPackage.id
            let cardPackageDocument = roomDocument.collection("cardPackages").document(
                cardPackageId)
            try await cardPackageDocument.setData([
                "id": cardPackageId,
                "themeColor": room.cardPackage.themeColor.rawValue,
                "createdAt": Timestamp(),
                "updatedAt": Date(),
            ])

            // カード一覧追加
            room.cardPackage.cardList.forEach { card in
                let cardId = card.id
                let cardDocument = cardPackageDocument.collection("cards").document(cardId)
                cardDocument.setData([
                    "id": cardId,
                    "point": card.point,
                    "index": card.index,
                    "createdAt": Timestamp(),
                    "updatedAt": Date(),
                ])
            }
            return .success(())
        } catch(_) {
            return .failure(.failedToCreateRoom)
        }
    }
}
