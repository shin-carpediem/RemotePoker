import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirebaseRef {
    var roomId: Int
    
    // MARK: - CollectionReference
    
    /// rooms / {roomId} / users
    var usersCollection: CollectionReference {
        roomsCollection.document(String(roomId)).collection("users")
    }
    
    /// rooms / {roomId} / cardPackages
    var cardPackagesCollection: CollectionReference {
        roomsCollection.document(String(roomId)).collection("cardPackages")
    }
    
    /// rooms / {roomId} / cardPackages / {cardPackageId} / cards
    func cardsCollection(cardPackageId: String) -> CollectionReference {
        cardPackagesCollection.document(cardPackageId).collection("cards")
    }
    
    // MARK: - QuerySnapshot
    
    /// rooms / {roomId} / users / *
    func usersDocument() async -> QuerySnapshot? {
        try? await usersCollection.getDocuments()
    }
    
    /// rooms / {roomId} / cardPackages / *
    func cardPackagesDocument() async -> QuerySnapshot? {
        try? await cardPackagesCollection.getDocuments()
    }
    
    /// rooms / {roomId} / cardPackages / {cardPackageId} / cards / *
    func cardsDocument(cardPackageId: String) async -> QuerySnapshot? {
        try? await cardsCollection(cardPackageId: cardPackageId).getDocuments()
    }
    
    // MARK: - DocumentReference
    
    var roomDocument: DocumentReference {
        roomsCollection.document(String(roomId))
    }
    
    func userDocument(userId: String) -> DocumentReference {
        usersCollection.document(userId)
    }
    
    // MARK: - Private
    
    private var roomsCollection: CollectionReference {
        Firestore.firestore().collection("rooms")
    }
}
