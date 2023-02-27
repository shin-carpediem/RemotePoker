import Foundation

final class LocalStorage {
    static let shared = LocalStorage()

    /// カレントルームID
    var currentRoomId: Int {
        get { UserDefaults.standard.integer(forKey: currentRoomIdKey) }
        set { UserDefaults.standard.set(newValue, forKey: currentRoomIdKey) }
    }

    /// カレントユーザーID
    var currentUserId: String {
        get { UserDefaults.standard.string(forKey: currentUserIdKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: currentUserIdKey) }
    }

    // MARK: - Private

    private init() {}

    /// カレントルームIDのキー
    private let currentRoomIdKey = "currentRoomId"

    /// カレントユーザーIDのキー
    private let currentUserIdKey = "currentUserId"
}
