import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class RoomDataStore: RoomRepository {
    func createRoom(_ room: Room) async {
        let roomId = room.id
        let roomCollection = Firestore.firestore().collection(rooms)
        let roomDocument = roomCollection.document(String(roomId))
        try? await roomDocument.setData([
            id: roomId,
            userIdList: room.userIdList
        ])
        
        let cardPackageId = room.cardPackage.id
        let cardPackagesCollection = roomDocument.collection(cardPackages)
        let cardPackageDocument = cardPackagesCollection.document(cardPackageId)
        try? await cardPackageDocument.setData([
            id: cardPackageId,
            themeColor: room.cardPackage.themeColor.rawValue
        ])
        
        room.cardPackage.cardList.forEach { card in
            let cardId = card.id
            let cardDocument = cardPackageDocument.collection(cards).document(cardId)
            cardDocument.setData([
                id: cardId,
                point: card.point,
                index: card.index
            ])
        }
    }
    
    func checkRoomExist(roomId: Int) async -> Bool {
        let roomCollection = Firestore.firestore().collection(rooms)
        guard let document = try? await roomCollection.document(String(roomId)).getDocument() else { return false }
        return document.exists
    }
    
    func fetchRoom(roomId: Int) async -> Room {
        let roomsCollection = Firestore.firestore().collection(rooms)
        let roomDocument = try? await roomsCollection.document(String(roomId)).getDocument()
        let roomData = roomDocument?.data()
        let roomId = roomData![id] as! Int
        let userIdList = roomData![userIdList] as! [String]
        
        let cardPackagesCollection = roomsCollection.document(id).collection(cardPackages)
        // TODO: cardPackagesDocumentがnil
        let cardPackagesDocument = try? await cardPackagesCollection.getDocuments().documents.first
        let cardPackageData = cardPackagesDocument?.data()
        let cardPackageId = cardPackageData![id] as! String
        let themeColor = cardPackageData![themeColor] as! ThemeColor
        
        let cardsCollection = cardPackagesCollection.document(cardPackageId).collection(cards)
        let cardsDocument = try? await cardsCollection.getDocuments().documents

        let cardList: [Card] = cardsDocument!.map { cardDoc in
            let cardData = cardDoc.data()
            return Card(id: cardData[id] as! String,
                        point: cardData[point] as! String,
                        index: cardData[index] as! Int)
        }
        
        let cardPackage = CardPackage(id: cardPackageId,
                                      themeColor: themeColor,
                                      cardList: cardList)

        let room = Room(id: roomId,
                        userIdList: userIdList,
                        cardPackage: cardPackage)

        return room
    }
    
    func addUserToRoom(roomId: Int, userId: String) async {
        let roomsCollection = Firestore.firestore().collection(rooms)

        let document = try? await roomsCollection.document(String(roomId)).getDocument()
        let data = document?.data()
        var list = data![userIdList] as! [String]
        list.append(userId)
        
        let room = roomsCollection.document(String(roomId))
        try? await room.updateData([
            userIdList: list
        ])
    }
    
    func removeUserFromRoom(roomId: Int, userId: String) async {
        let roomsCollection = Firestore.firestore().collection(rooms)
        
        let document = try? await roomsCollection.document(String(roomId)).getDocument()
        let data = document?.data()
        var list = data![userIdList] as! [String]
        list.removeAll(where: { $0 == userId })
        
        let room = roomsCollection.document(String(roomId))
        try? await room.updateData([
            userIdList: list
        ])
    }
    
    func deleteRoom(roomId: Int) async {
        let roomsCollection = Firestore.firestore().collection(rooms)
        let document = roomsCollection.document(String(roomId))
        try? await document.delete()
    }
    
    // MARK: - Private
    
    private let id = "id"
    
    private let rooms = "rooms"
    
    private let cardPackages = "cardPackages"
    
    private let cards = "cards"
    
    private let userIdList = "userIdList"
    
    private let cardPackage = "cardPackage"
    
    private let themeColor = "themeColor"
    
    private let point = "point"
    
    private let index = "index"
}
