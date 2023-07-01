import FirebaseFirestore
import FirebaseFirestoreSwift

public struct FirestoreRefs {
    public var roomId: Int

    public init(roomId: Int) {
        self.roomId = roomId
    }

    // MARK: - CollectionReference

    /// rooms / { roomId } / users
    public var usersCollection: CollectionReference {
        roomsCollection.document(String(roomId)).collection("users")
    }

    /// rooms / { roomId } / cardPackages
    public var cardPackagesCollection: CollectionReference {
        roomsCollection.document(String(roomId)).collection("cardPackages")
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards
    public func cardsCollection(cardPackageId: String) -> CollectionReference {
        cardPackagesCollection.document(cardPackageId).collection("cards")
    }

    // MARK: - DocumentReference

    /// rooms / { roomId }
    public var roomDocument: DocumentReference {
        roomsCollection.document(String(roomId))
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId }
    public func cardPackageDocument(cardPackageId: String) -> DocumentReference {
        cardPackagesCollection.document(cardPackageId)
    }

    /// rooms /  {roomId } / users / { userId }
    public func userDocument(userId: String) -> DocumentReference {
        usersCollection.document(userId)
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards / { cardId }
    public func cardDocument(cardPackageId: String, cardId: String) -> DocumentReference {
        cardsCollection(cardPackageId: cardPackageId).document(cardId)
    }

    // MARK: - DocumentSnapshot

    /// rooms / { roomId }
    public func roomSnapshot() async -> DocumentSnapshot? {
        try? await roomDocument.getDocument()
    }

    // MARK: - Query

    /// rooms / { roomId } / cardPackages / *
    public var cardPackagesQuery: Query {
        cardPackagesCollection.whereField("id", isNotEqualTo: "")
    }

    /// rooms / { roomId } / users / *
    public var usersQuery: Query {
        usersCollection.whereField("id", isNotEqualTo: "")
    }

    // MARK: - QueryDocumentSnapshot

    /// rooms / { roomId } / users / *
    public func usersSnapshot() async -> [QueryDocumentSnapshot]? {
        try? await usersCollection.getDocuments().documents
    }

    /// rooms / { roomId } / cardPackages / *
    public func cardPackagesSnapshot() async -> [QueryDocumentSnapshot]? {
        try? await cardPackagesCollection.getDocuments().documents
    }

    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards / *
    public func cardsSnapshot(cardPackageId: String) async -> [QueryDocumentSnapshot]? {
        try? await cardsCollection(cardPackageId: cardPackageId).getDocuments().documents
    }

    // MARK: - Private

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
