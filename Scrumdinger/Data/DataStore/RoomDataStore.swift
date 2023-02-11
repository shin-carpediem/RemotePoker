import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class RoomDataStore: RoomRepository {
    init(roomId: Int) {
        self.roomId = roomId
    }

    // MARK: - RoomRepository

    func fetchRoom() async -> Result<RoomEntity, FirebaseError> {
        // ルーム取得
        let roomSnapshot = await firestoreRef.roomSnapshot()
        let roomData = roomSnapshot?.data()
        guard let roomData = roomData else {
            return .failure(.failedToFetchRoom)
        }
        let roomId = roomData["id"] as! Int

        // ユーザー一覧取得
        let usersSnapshot = await firestoreRef.usersSnapshot()
        let userList: [UserEntity] = usersSnapshot!.map { userDoc in
            let userData = userDoc.data()
            return UserEntity(
                id: userData["id"] as! String,
                name: userData["name"] as! String,
                currentRoomId: userData["currentRoomId"] as! Int,
                selectedCardId: userData["selectedCardId"] as! String)
        }

        // カードパッケージ取得
        let cardPackagesSnapshot = await firestoreRef.cardPackagesSnapshot()?.first
        let cardPackageData = cardPackagesSnapshot?.data()
        let cardPackageId = cardPackageData!["id"] as! String
        let themeColor = cardPackageData!["themeColor"] as! String

        // カード一覧取得
        let cardsSnapshot = await firestoreRef.cardsSnapshot(cardPackageId: cardPackageId)
        let cardList: [CardPackageEntity.Card] = cardsSnapshot!.map { cardDoc in
            let cardData = cardDoc.data()
            return CardPackageEntity.Card(
                id: cardData["id"] as! String,
                point: cardData["point"] as! String,
                index: cardData["index"] as! Int)
        }.sorted { $0.index < $1.index }

        let cardPackage = CardPackageEntity(
            id: cardPackageId,
            themeColor: CardPackageEntity.ThemeColor(rawValue: themeColor)!,
            cardList: cardList)

        let room = RoomEntity(
            id: roomId,
            userList: userList,
            cardPackage: cardPackage)

        return .success(room)
    }

    func addUserToRoom(user: UserEntity) async -> Result<Void, FirebaseError> {
        do {
            let userDocument = firestoreRef.usersCollection.document(user.id)
            try await userDocument.setData([
                "id": user.id,
                "name": user.name,
                "currentRoomId": user.currentRoomId,
                "selectedCardId": user.selectedCardId,
                "createdAt": Timestamp(),
                "updatedAt": Date(),
            ])
            return .success(())
        } catch {
            return .failure(.failedToAddUserToRoom)
        }
    }

    func removeUserFromRoom(userId: String) async -> Result<Void, FirebaseError> {
        do {
            try await firestoreRef.userDocument(userId: userId).delete()
            return .success(())
        } catch {
            return .failure(.failedToRemoveUserFromRoom)
        }
    }

    func subscribeUser(
        completion: @escaping (Result<FireStoreDocumentChanges, FirebaseError>) -> Void
    ) {
        usersListener = firestoreRef.usersQuery.addSnapshotListener { querySnapshot, error in
            querySnapshot?.documentChanges.forEach { diff in
                var diffType: FireStoreDocumentChanges
                if diff.type == .added {
                    diffType = .added
                } else if diff.type == .modified {
                    diffType = .modified
                } else if diff.type == .removed {
                    diffType = .removed
                } else {
                    completion(.failure(.failedToSubscribeUser))
                    return
                }
                completion(.success(diffType))
            }
        }
    }

    func fetchUser(id: String, completion: @escaping (UserEntity) -> Void) {
        let userDocument = firestoreRef.userDocument(userId: id)
        userDocument.getDocument { userSnapshot, _ in
            let userData = userSnapshot?.data()
            let user: UserEntity = .init(
                id: userData?["id"] as! String,
                name: userData?["name"] as! String,
                currentRoomId: userData?["currentRoomId"] as! Int,
                selectedCardId: userData?["selectedCardId"] as! String)
            completion(user)
        }
    }

    func unsubscribeUser() {
        usersListener?.remove()
    }

    func subscribeCardPackage(
        completion: @escaping (Result<FireStoreDocumentChanges, FirebaseError>) -> Void
    ) {
        cardPackagesListener = firestoreRef.cardPackagesQuery.addSnapshotListener {
            querySnapshot, error in
            querySnapshot?.documentChanges.forEach { diff in
                var diffType: FireStoreDocumentChanges
                if diff.type == .added {
                    diffType = .added
                } else if diff.type == .modified {
                    diffType = .modified
                } else if diff.type == .removed {
                    diffType = .removed
                } else {
                    completion(.failure(.failedToSubscribeCardPackage))
                    return
                }
                completion(.success(diffType))
            }
        }
    }

    func unsubscribeCardPackage() {
        cardPackagesListener?.remove()
    }

    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        selectedCardDictionary.forEach { userId, selectedCardId in
            let userDocument = firestoreRef.userDocument(userId: userId)
            userDocument.updateData([
                "selectedCardId": selectedCardId,
                "updatedAt": Date(),
            ])
        }
    }

    func updateThemeColor(cardPackageId: String, themeColor: CardPackageEntity.ThemeColor) {
        let cardPackageDocument = firestoreRef.cardPackageDocument(cardPackageId: cardPackageId)
        cardPackageDocument.updateData([
            "themeColor": themeColor.rawValue,
            "updatedAt": Date(),
        ])
    }

    // MARK: - Private

    /// ルームID
    private var roomId: Int!

    /// Firestoreのリファレンス一覧
    private var firestoreRef: FirestoreRef {
        FirestoreRef(roomId: roomId)
    }

    /// ルーム内ユーザーのリスナー
    private var usersListener: ListenerRegistration?

    /// ルームのカードパッケージのリスナー
    private var cardPackagesListener: ListenerRegistration?
}
