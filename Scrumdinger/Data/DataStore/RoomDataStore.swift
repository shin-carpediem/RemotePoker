import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class RoomDataStore: RoomRepository {
    init() {}

    convenience init(roomId: Int) {
        self.init()
        firestoreRef = FirestoreRef(roomId: roomId)
    }

    // MARK: - RoomRepository

    func checkRoomExist(roomId: Int) async -> Bool {
        let roomDocument = Firestore.firestore().collection("rooms").document(String(roomId))
        guard let document = try? await roomDocument.getDocument() else { return false }
        return document.exists
    }

    func createRoom(_ room: Room) async -> Result<Void, RoomError> {
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
        } catch {
            return .failure(.failedToCreateRoom)
        }
    }

    func fetchRoom() async -> Result<Room, RoomError> {
        guard let firestoreRef = firestoreRef else {
            return .failure(.failedToFetchRoom)
        }

        // ルーム取得
        let roomSnapshot = await firestoreRef.roomSnapshot()
        let roomData = roomSnapshot?.data()
        guard let roomData = roomData else {
            return .failure(.failedToFetchRoom)
        }
        let roomId = roomData["id"] as! Int

        // ユーザー一覧取得
        let usersSnapshot = await firestoreRef.usersSnapshot()
        let userList: [User] = usersSnapshot!.map { userDoc in
            let userData = userDoc.data()
            return User(
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
        let cardList: [Card] = cardsSnapshot!.map { cardDoc in
            let cardData = cardDoc.data()
            return Card(
                id: cardData["id"] as! String,
                point: cardData["point"] as! String,
                index: cardData["index"] as! Int)
        }.sorted { $0.index < $1.index }

        let cardPackage = CardPackage(
            id: cardPackageId,
            themeColor: ThemeColor(rawValue: themeColor)!,
            cardList: cardList)

        let room = Room(
            id: roomId,
            userList: userList,
            cardPackage: cardPackage)

        return .success(room)
    }

    func addUserToRoom(user: User) async -> Result<Void, RoomError> {
        guard let firestoreRef = firestoreRef else {
            return .failure(.failedToAddUserToRoom)
        }

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

    func removeUserFromRoom(userId: String) async -> Result<Void, RoomError> {
        guard let firestoreRef = firestoreRef else {
            return .failure(.failedToRemoveUserFromRoom)
        }

        do {
            try await firestoreRef.userDocument(userId: userId).delete()
            return .success(())
        } catch {
            return .failure(.failedToRemoveUserFromRoom)
        }
    }

    func subscribeUser(completion: @escaping (Result<UserAction, RoomError>) -> Void) {
        guard let firestoreRef = firestoreRef else {
            completion(.failure(.failedToSubscribeUser))
            return
        }

        usersListener = firestoreRef.usersQuery.addSnapshotListener { querySnapshot, error in
            querySnapshot?.documentChanges.forEach { diff in
                var action: UserAction
                if diff.type == .added {
                    action = .added
                } else if diff.type == .modified {
                    action = .modified
                } else if diff.type == .removed {
                    action = .removed
                } else {
                    completion(.failure(.failedToSubscribeUser))
                    return
                }

                completion(.success(action))
            }
        }
    }

    func fetchUser(id: String, completion: @escaping (User) -> Void) {
        guard let firestoreRef = firestoreRef else { fatalError() }

        let userDocument = firestoreRef.userDocument(userId: id)
        userDocument.getDocument { userSnapshot, _ in
            let userData = userSnapshot?.data()
            let user: User = .init(
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

    func subscribeCardPackage(completion: @escaping (Result<CardPackageAction, RoomError>) -> Void)
    {
        guard let firestoreRef = firestoreRef else {
            completion(.failure(.failedToSubscribeCardPackage))
            return
        }

        cardPackagesListener = firestoreRef.cardPackagesQuery.addSnapshotListener {
            querySnapshot, error in
            querySnapshot?.documentChanges.forEach { diff in
                var action: CardPackageAction
                if diff.type == .added {
                    action = .added
                } else if diff.type == .modified {
                    action = .modified
                } else if diff.type == .removed {
                    action = .removed
                } else {
                    completion(.failure(.failedToSubscribeCardPackage))
                    return
                }

                completion(.success(action))
            }
        }
    }

    func unsubscribeCardPackage() {
        cardPackagesListener?.remove()
    }

    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        guard let firestoreRef = firestoreRef else { fatalError() }

        selectedCardDictionary.forEach { userId, selectedCardId in
            let userDocument = firestoreRef.userDocument(userId: userId)
            userDocument.updateData([
                "selectedCardId": selectedCardId,
                "updatedAt": Date(),
            ])
        }
    }

    func updateThemeColor(cardPackageId: String, themeColor: ThemeColor) {
        guard let firestoreRef = firestoreRef else { fatalError() }

        let cardPackageDocument = firestoreRef.cardPackageDocument(cardPackageId: cardPackageId)
        cardPackageDocument.updateData([
            "themeColor": themeColor.rawValue,
            "updatedAt": Date(),
        ])
    }

    // MARK: - Private

    /// Firestoreのリファレンス一覧
    private var firestoreRef: FirestoreRef?

    /// ルーム内ユーザーのリスナー
    private var usersListener: ListenerRegistration?

    /// ルームのカードパッケージのリスナー
    private var cardPackagesListener: ListenerRegistration?
}
