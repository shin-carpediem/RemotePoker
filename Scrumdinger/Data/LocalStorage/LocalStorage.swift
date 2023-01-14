import Foundation

final class LocalStorage {
    static let shared = LocalStorage()

    /// カレントルームID
    var currentRoomId: Int {
        get { UserDefaults.standard.integer(forKey: "currentRoomId") }
        set { UserDefaults.standard.set(newValue, forKey: "currentRoomId") }
    }
}
