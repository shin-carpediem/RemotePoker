import Foundation

public final class LocalStorage {
    public static let shared = LocalStorage()

    public var currentRoomId: Int {
        get { UserDefaults.standard.integer(forKey: currentRoomIdKey) }
        set { UserDefaults.standard.set(newValue, forKey: currentRoomIdKey) }
    }

    public var currentUserId: String {
        get { UserDefaults.standard.string(forKey: currentUserIdKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: currentUserIdKey) }
    }

    // MARK: - Private

    private init() {}

    private let currentRoomIdKey = "currentRoomId"

    private let currentUserIdKey = "currentUserId"
}
