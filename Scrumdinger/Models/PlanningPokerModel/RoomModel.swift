import Foundation

struct RoomModel: Identifiable {
    let id: UUID = UUID()
    var usersId: [UUID]
}

extension RoomModel {
    static let sampleData: RoomModel = RoomModel(usersId: [UUID(), UUID(), UUID()])
}
