import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

public final class CurrentRoomDataStore: CurrentRoomRepository {
    public init(userId: String, roomId: String) {
        self.userId = userId
        self.roomId = roomId
    }

    // MARK: - RoomRepository

    public var userList: PassthroughSubject<[UserEntity], Never> {
        let subject = PassthroughSubject<[UserEntity], Never>()
        Task {
            await firestoreRef.userListQuery().addSnapshotListener { snapshot, error in
                if error != nil { return }
                guard let snapshot = snapshot else { return }
                let userList: [UserEntity] = snapshot.documents.map {  Self.userEntity(from: $0)
                }
                subject.send(userList)
            }
        }
        return subject
    }
    
    public var room: PassthroughSubject<RoomEntity, Never> {
        let subject = PassthroughSubject<RoomEntity, Never>()
        firestoreRef.roomQuery.addSnapshotListener { snapshot, error in
            if error != nil { return }
            guard let snapshot = snapshot else { return }
            guard let document = snapshot.documents.first else { return }
            Task { [weak self] in
                guard let self = self else { return }
                let room: RoomEntity = await self.roomEntity(from: document)
                subject.send(room)
            }
        }
        return subject
    }

    public func addUserToRoom() async -> Result<Void, FirebaseError> {
        do {
            try await firestoreRef.roomDocument.updateData([
                "userIdList": FieldValue.arrayUnion([userId]),
                "updatedAt": Date(),
            ])
            return .success(())
        } catch (_) {
            Log.main.error("failedToAddUserToRoom")
            return .failure(.failedToAddUserToRoom)
        }
    }

    public func removeUserFromRoom() async -> Result<Void, FirebaseError> {
        do {
            try await firestoreRef.roomDocument.updateData([
                "userIdList": FieldValue.arrayRemove([userId]),
                "updatedAt": Date(),
            ])
            return .success(())
        } catch (_) {
            Log.main.error("failedToRemoveUserFromRoom")
            return .failure(.failedToRemoveUserFromRoom)
        }
    }

    public func fetchUser() -> Future<UserEntity, FirebaseError> {
        Future<UserEntity, FirebaseError> { [unowned self] promise in
            firestoreRef.userDocument.getDocument { snapshot, _ in
                if let snapshot {
                    promise(.success(Self.userEntity(from: snapshot)))
                } else {
                    promise(.failure(.failedToFetchUser))
                }
            }
        }
    }

    public func updateSelectedCardId(selectedCardDictionary: [String: Int]) {
        selectedCardDictionary.forEach { _, selectedCardId in
            firestoreRef.userDocument.updateData([
                "selectedCardId": selectedCardId,
                "updatedAt": Date(),
            ])
        }
    }

    public func updateThemeColor(cardPackageId: String, themeColor: String) {
        firestoreRef.cardPackageDocument(cardPackageId: cardPackageId).updateData([
            "themeColor": themeColor,
            "updatedAt": Date(),
        ])
    }
    
    public func unsubscribeUserList() {
        userList.send(completion: .finished)
    }

    public func unsubscribeRoom() {
        room.send(completion: .finished)
    }

    // MARK: - Private

    private let userId: String
    private let roomId: String

    /// Firestoreのリファレンス一覧
    private var firestoreRef: FirestoreRefs {
        FirestoreRefs(userId: userId, roomId: roomId)
    }

    private static func userEntity(from doc: DocumentSnapshot) -> UserEntity {
        guard let id = doc.get("id") as? String else {
            Log.main.error("failedToTranslateUserEntityFromDoc")
            fatalError()
        }
        return UserEntity(
            id: id,
            name: doc.get("name") as? String ?? "",
            selectedCardId: doc.get("selectedCardId") as? Int ?? 0)
    }
    
    private func roomEntity(from doc: DocumentSnapshot) async -> RoomEntity {
        guard let roomId = doc.get("id") as? Int else {
            Log.main.error("failedToTranslateRoomEntityFromDoc")
            fatalError()
        }

        let cardPackageSnapshot = await firestoreRef.cardPackagesSnapshot()?.first
        guard let cardPackageSnapshot = cardPackageSnapshot else {
            Log.main.error("failedToTranslateRoomEntityFromDoc")
            fatalError()
        }

        let cardPackageId: String = cardPackageSnapshot.documentID
        let cardsSnapshot = await firestoreRef.cardsSnapshot(cardPackageId: cardPackageId)
        guard let cardsSnapshot = cardsSnapshot else {
            Log.main.error("failedToTranslateRoomEntityFromDoc")
            fatalError()
        }

        let cardList: [CardPackageEntity.Card] = cardsSnapshot.map { doc in
            guard let cardId = doc.get("id") as? Int else {
                Log.main.error("failedToTranslateRoomEntityFromDoc")
                fatalError()
            }
            return CardPackageEntity.Card(
                id: cardId,
                estimatePoint: doc.get("estimatePoint") as? String ?? "",
                index: doc.get("index") as? Int ?? 0)
        }.sorted { $0.index < $1.index }

        let cardPackage = CardPackageEntity(
            id: Int(cardPackageId) ?? 0,
            themeColor: doc.get("themeColor") as? String ?? "",
            cardList: cardList)
        
        return RoomEntity(id: roomId,
                          userIdList: doc.get("userIdList") as? [String] ?? [String](),
                          cardPackage: cardPackage)
    }
}
