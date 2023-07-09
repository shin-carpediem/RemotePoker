import Foundation

public final class LocalStorage {
    public static let shared = LocalStorage()

    public var currentUserId: String {
        get { UserDefaults.standard.string(forKey: currentUserIdKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: currentUserIdKey) }
    }

    public var currentRoomId: Int {
        get { UserDefaults.standard.integer(forKey: currentRoomIdKey) }
        set { UserDefaults.standard.set(newValue, forKey: currentRoomIdKey) }
    }
    
    // MARK: - Private

    private init() {}

    private let currentUserIdKey = "currentUserId"
    
    private let currentRoomIdKey = "currentRoomId"
}
