import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

public final class EnterRoomDataStore: EnterRoomRepository {
    public init() {}

    // MARK: - EnterRoomRepository
    
    // TODO: これが一切呼ばれてない
    public func createUser(_ user: UserEntity) async -> Result<Void, FirebaseError> {
        do {
            try await firestore.collection("users").document(String(user.id)).setData([
                "id": user.id,
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
        guard let document: DocumentSnapshot = try? await firestore.collection("rooms").document(
            roomId).getDocument() else {
            return false
        }
        return document.exists
    }

    public func createRoom(_ room: RoomEntity) async -> Result<Void, FirebaseError> {
        do {
            let timestamp = Timestamp()
            let date = Date()
            
            // ルーム追加
            let roomDocument: DocumentReference = firestore.collection("rooms")
                .document(String(room.id))
            try await roomDocument.setData([
                "id": room.id,
                "userIdList": room.userIdList,
                "createdAt": timestamp,
                "updatedAt": date,
            ])

            // カードパッケージ追加
            let cardPackageDocument: DocumentReference = roomDocument.collection("cardPackages")
                .document(
                    room.cardPackage.id)
            try await cardPackageDocument.setData([
                "id": room.cardPackage.id,
                "themeColor": room.cardPackage.themeColor,
                "createdAt": timestamp,
                "updatedAt": date,
            ])

            // カード一覧追加
            room.cardPackage.cardList.forEach {
                cardPackageDocument.collection("cards").document($0.id).setData([
                    "id": $0.id,
                    "estimatePoint": $0.estimatePoint,
                    "index": $0.index,
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
