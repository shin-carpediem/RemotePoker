import Foundation

class RoomModel: Identifiable {
    let id: UUID = UUID()
    var usersId: [UUID] = []
    var cardList: [EstimateNumberSetModel] = [EstimateNumberSetModel.sampleData]
    
    // MARK: - Method
    
    func addUserToRoom(_ userId: UUID) {
        usersId.append(userId)
    }
    
    func removeUserFromRoom(_ userId: UUID) {
        usersId.removeAll(where: {$0 == userId})
    }
}

extension RoomModel {
    static let sampleData: RoomModel = RoomModel()
}
