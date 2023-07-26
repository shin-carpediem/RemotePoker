import FirebaseFirestore
import FirebaseFirestoreSwift

public struct FirestoreRefs {
    public init(userId: String,roomId: String) {
        self.userId = userId
        self.roomId = roomId
    }
    
    // MARK: - CollectionReference
    
    /// users
    public var usersCollection: CollectionReference {
        firestore.collection("users")
    }
    
    /// rooms / { roomId } / cardPackages
    public var cardPackagesCollection: CollectionReference {
        roomsCollection.document(roomId).collection("cardPackages")
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards
    public func cardsCollection(cardPackageId: String) -> CollectionReference {
        cardPackagesCollection.document(cardPackageId).collection("cards")
    }

    // MARK: - DocumentReference

    /// users / { userId }
    public var userDocument: DocumentReference {
        usersCollection.document(userId)
    }
    
    /// rooms / { roomId }
    public var roomDocument: DocumentReference {
        roomsCollection.document(roomId)
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId }
    public func cardPackageDocument(cardPackageId: String) -> DocumentReference {
        cardPackagesCollection.document(cardPackageId)
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards / { cardId }
    public func cardDocument(cardPackageId: String, cardId: String) -> DocumentReference {
        cardsCollection(cardPackageId: cardPackageId).document(cardId)
    }

    // MARK: - DocumentSnapshot

    /// users / { userId }
    public func userSnapshot() async -> DocumentSnapshot? {
        try? await roomDocument.getDocument()
    }
    
    /// rooms / { roomId }
    public func roomSnapshot() async -> DocumentSnapshot? {
        try? await roomDocument.getDocument()
    }

    // MARK: - Query
    
    /// users / { roomId の userIdList }
    public func userListQuery() async -> Query {
        guard let roomSnapshot: DocumentSnapshot = await roomSnapshot() else {
            Log.main.error("usersListQuery: roomSnapshotを取得できません。")
            fatalError()
        }
        guard let userIdList: [String] = roomSnapshot.get("userIdList") as? [String] else {
            Log.main.error("usersListQuery: userIdListを取得できません。")
            fatalError()
        }
        if userIdList.isEmpty {
            Log.main.error("usersListQuery: userIdListが空です。")
            fatalError()
        }
        return usersCollection.whereField("id", in: userIdList)
    }
    
    /// rooms / { roomId }
    public var roomQuery: Query {
        guard let roomId = Int(roomId) else {
            Log.main.error("roomQuery: roomIdをIntに変換できません。")
            fatalError()
        }
        return roomsCollection.whereField("id", isEqualTo: roomId)
    }

    /// rooms / { roomId } / cardPackages / *
    public var cardPackagesQuery: Query {
        cardPackagesCollection.whereField("id", isNotEqualTo: "")
    }

    // MARK: - QueryDocumentSnapshot

    /// rooms / { roomId } / cardPackages / *
    public func cardPackagesSnapshot() async -> [QueryDocumentSnapshot]? {
        try? await cardPackagesCollection.getDocuments().documents
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards / *
    public func cardsSnapshot(cardPackageId: String) async -> [QueryDocumentSnapshot]? {
        try? await cardsCollection(cardPackageId: cardPackageId).getDocuments().documents
    }

    // MARK: - Private
    
    private var userId: String
    private var roomId: String
    
    private var firestore: Firestore {
        guard let app = FirebaseEnvironment.shared.app else {
            fatalError("Could not retrieve app.")
        }
        return Firestore.firestore(app: app)
    }
    
    /// rooms
    private var roomsCollection: CollectionReference {
        firestore.collection("rooms")
    }
}
