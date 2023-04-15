import Foundation

public final class LocalStorage {
    public static let shared = LocalStorage()

    /// カレントルームID
    public var currentRoomId: Int {
        get { UserDefaults.standard.integer(forKey: currentRoomIdKey) }
        set { UserDefaults.standard.set(newValue, forKey: currentRoomIdKey) }
    }

    /// カレントユーザーID
    public var currentUserId: String {
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
