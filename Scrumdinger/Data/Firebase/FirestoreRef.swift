import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreRef {
    var roomId: Int
    
    // MARK: - CollectionReference
    
    /// rooms / { roomId } / users
    var usersCollection: CollectionReference {
        roomsCollection.document(String(roomId)).collection("users")
    }
    
    /// rooms / { roomId } / cardPackages
    var cardPackagesCollection: CollectionReference {
        roomsCollection.document(String(roomId)).collection("cardPackages")
    }
    
    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards
    func cardsCollection(cardPackageId: String) -> CollectionReference {
        cardPackagesCollection.document(cardPackageId).collection("cards")
    }
    
    // MARK: - DocumentReference
    
    /// rooms / { roomId }
    var roomDocument: DocumentReference {
        roomsCollection.document(String(roomId))
    }
    
    /// rooms / { roomId } / cardPackages / { cardPackageId }
    func cardPackageDocument(cardPackageId: String) -> DocumentReference {
        cardPackagesCollection.document(cardPackageId)
    }
    
    /// rooms /  {roomId } / users / { userId }
    func userDocument(userId: String) -> DocumentReference {
        usersCollection.document(userId)
    }
    
    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards / { cardId }
    func cardDocument(cardPackageId: String, cardId: String) -> DocumentReference {
        cardsCollection(cardPackageId: cardPackageId).document(cardId)
    }
    
    // MARK: - DocumentSnapshot
    
    /// rooms / { roomId }
    func roomSnapshot() async -> DocumentSnapshot? {
        try? await roomDocument.getDocument()
    }
    
    // MARK: - Query
    
    /// rooms / { roomId } / cardPackages / *
    var cardPackagesQuery: Query {
        cardPackagesCollection.whereField("id", isNotEqualTo: "")
    }
    
    /// rooms / { roomId } / users / *
    var usersQuery: Query {
        usersCollection.whereField("id", isNotEqualTo: "")
    }
    
    // MARK: - QueryDocumentSnapshot
    
    /// rooms / { roomId } / users / *
    func usersSnapshot() async -> [QueryDocumentSnapshot]? {
        try? await usersCollection.getDocuments().documents
    }
    
    /// rooms / { roomId } / cardPackages / *
    func cardPackagesSnapshot() async -> [QueryDocumentSnapshot]? {
        try? await cardPackagesCollection.getDocuments().documents
    }
    
    /// rooms / { roomId } / cardPackages / { cardPackageId } / cards / *
    func cardsSnapshot(cardPackageId: String) async -> [QueryDocumentSnapshot]? {
        try? await cardsCollection(cardPackageId: cardPackageId).getDocuments().documents
    }
    
    // MARK: - Private
    
    /// rooms
    private var roomsCollection: CollectionReference {
        Firestore.firestore().collection("rooms")
    }
}
