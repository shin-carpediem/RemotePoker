import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

public final class EnterRoomDataStore: EnterRoomRepository {
    public init() {}

    // MARK: - EnterRoomRepository
    
    public func createUser(_ user: UserEntity) async -> Result<Void, FirebaseError> {
        do {
            let userId: String = user.id
            let userDocument: DocumentReference = firestore.collection("users").document(String(userId))
            try await userDocument.setData([
                "id": userId,
                "name": user.name,
                "selectedCardId": user.selectedCardId,
                "createdAt": Timestamp(),
                "updatedAt": Date(),
            ])
            return .success(())
        } catch (_) {
            Log.main.error("failedToCreateUser")
            return .failure(.failedToCreateUser)
        }
    }

    public func checkRoomExist(roomId: String) async -> Bool {
        let roomDocument: DocumentReference =
            firestore.collection("rooms").document(
                roomId)
        guard let document: DocumentSnapshot = try? await roomDocument.getDocument() else {
            return false
        }
        return document.exists
    }

    public func createRoom(_ room: RoomEntity) async -> Result<Void, FirebaseError> {
        do {
            let timestamp = Timestamp()
            let date = Date()
            
            // ルーム追加
            let roomId: Int = room.id
            let roomDocument: DocumentReference = firestore.collection("rooms")
                .document(String(roomId))
            try await roomDocument.setData([
                "id": roomId,
                "userIdList": [String](),
                "createdAt": timestamp,
                "updatedAt": date,
            ])

            // カードパッケージ追加
            let cardPackageId: String = room.cardPackage.id
            let cardPackageDocument: DocumentReference = roomDocument.collection("cardPackages")
                .document(
                    cardPackageId)
            try await cardPackageDocument.setData([
                "id": cardPackageId,
                "themeColor": room.cardPackage.themeColor,
                "createdAt": timestamp,
                "updatedAt": date,
            ])

            // カード一覧追加
            room.cardPackage.cardList.forEach { card in
                let cardId: String = card.id
                let cardDocument: DocumentReference = cardPackageDocument.collection("cards")
                    .document(cardId)
                cardDocument.setData([
                    "id": cardId,
                    "estimatePoint": card.estimatePoint,
                    "index": card.index,
                    "createdAt": timestamp,
                    "updatedAt": date,
                ])
            }
            return .success(())
        } catch (_) {
            Log.main.error("failedToCreateRoom")
            return .failure(.failedToCreateRoom)
        }
    }

    // MARK: - Private

    private var firestore: Firestore {
        guard let app = FirebaseEnvironment.shared.app else {
            Log.main.error("Could not retrieve app.")
            fatalError("Could not retrieve app.")
        }
        return Firestore.firestore(app: app)
    }
}
