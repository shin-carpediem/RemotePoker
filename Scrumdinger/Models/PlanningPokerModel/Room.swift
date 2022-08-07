import Foundation

struct Room: Identifiable {
    let id: UUID = UUID()
    var usersId: [UUID]
}

extension Room {
    static let sampleData: Room = Room(usersId: [UUID(), UUID(), UUID()])
}
