import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class RoomDataStore: RoomRepository {
    init(roomId: Int) {
        self.roomId = roomId
    }

    // MARK: - RoomRepository

    lazy var userList: PassthroughSubject<[UserEntity], Never> = {
        let subject = PassthroughSubject<[UserEntity], Never>()
        firestoreRef.usersQuery.addSnapshotListener { snapshot, error in
            if let error = error { return }
            guard let snapshot = snapshot else { return }
            let userList: [UserEntity] = snapshot.documents.map { doc in
                Self.userEntity(from: doc)
            }
            subject.send(userList)
        }
        return subject
    }()

    lazy var cardPackage: PassthroughSubject<CardPackageEntity, Never> = {
        let subject = PassthroughSubject<CardPackageEntity, Never>()
        firestoreRef.cardPackagesQuery.addSnapshotListener { snapshot, error in
            if let error = error { return }
            guard let snapshot = snapshot else { return }
            guard let document = snapshot.documents.first else { return }
            Task { [weak self] in
                guard let self = self else { return }
                let cardPackage: CardPackageEntity = await self.cardPackageEntity(from: document)
                subject.send(cardPackage)
            }
        }
        return subject
    }()

    func addUserToRoom(user: UserEntity) async -> Result<Void, FirebaseError> {
        do {
            let userDocument: DocumentReference = firestoreRef.usersCollection.document(user.id)
            try await userDocument.setData([
                "id": user.id,
                "name": user.name,
                "currentRoomId": user.currentRoomId,
                "selectedCardId": user.selectedCardId,
                "createdAt": Timestamp(),
                "updatedAt": Date(),
            ])
            return .success(())
        } catch (_) {
            return .failure(.failedToAddUserToRoom)
        }
    }

    func removeUserFromRoom(userId: String) async -> Result<Void, FirebaseError> {
        do {
            try await firestoreRef.userDocument(userId: userId).delete()
            return .success(())
        } catch (_) {
            return .failure(.failedToRemoveUserFromRoom)
        }
    }

    func fetchUser(byId id: String) -> Future<UserEntity, Never> {
        Future<UserEntity, Never> { [unowned self] promise in
            let userDocument: DocumentReference = self.firestoreRef.userDocument(userId: id)
            userDocument.getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                let user: UserEntity = Self.userEntity(from: snapshot)
                promise(.success(user))
            }
        }
    }

    func updateSelectedCardId(selectedCardDictionary: [String: String]) {
        selectedCardDictionary.forEach { userId, selectedCardId in
            let userDocument: DocumentReference = firestoreRef.userDocument(userId: userId)
            userDocument.updateData([
                "selectedCardId": selectedCardId,
                "updatedAt": Date(),
            ])
        }
    }

    func updateThemeColor(cardPackageId: String, themeColor: CardPackageEntity.ThemeColor) {
        let cardPackageDocument: DocumentReference = firestoreRef.cardPackageDocument(cardPackageId: cardPackageId)
        cardPackageDocument.updateData([
            "themeColor": themeColor.rawValue,
            "updatedAt": Date(),
        ])
    }

    func unsubscribeUser() {
        userList.send(completion: .finished)
    }

    func unsubscribeCardPackage() {
        cardPackage.send(completion: .finished)
    }

    // MARK: - Private

    /// ルームID
    private let roomId: Int

    /// Firestoreのリファレンス一覧
    private var firestoreRef: FirestoreRefs {
        FirestoreRefs(roomId: roomId)
    }

    /// ユーザー エンティティ
    private static func userEntity(from doc: DocumentSnapshot) -> UserEntity {
        guard let id = doc.get("id") as? String else {
            fatalError()
        }
        return UserEntity(
            id: id,
            name: doc.get("name") as? String ?? "",
            currentRoomId: doc.get("currentRoomId") as? Int ?? 0,
            selectedCardId: doc.get("selectedCardId") as? String ?? "")
    }

    /// カードパッケージ エンティティ
    private func cardPackageEntity(from doc: DocumentSnapshot) async -> CardPackageEntity {
        guard let id = doc.get("id") as? String else {
            fatalError()
        }
        let themeColor = doc.get("themeColor") as? String ?? ""

        // カード一覧取得
        let cardsSnapshot = await firestoreRef.cardsSnapshot(cardPackageId: id)
        guard let cardsSnapshot = cardsSnapshot else {
            fatalError()
        }
        let cardList: [CardPackageEntity.Card] = cardsSnapshot.map { doc in
            guard let cardId = doc.get("id") as? String else {
                fatalError()
            }
            return CardPackageEntity.Card(
                id: cardId,
                point: doc.get("point") as? String ?? "",
                index: doc.get("index") as? Int ?? 0)
        }.sorted { $0.index < $1.index }

        return CardPackageEntity(
            id: id,
            themeColor: CardPackageEntity.ThemeColor(rawValue: themeColor) ?? .oxblood,
            cardList: cardList)
    }
}
