import Foundation

class AppConfig {
    class var shared: AppConfig {
        struct Static {
            static let instance: AppConfig = .init()
        }
        return Static.instance
    }
    
    func addLocalLogInData(userId: String?,
                           userName: String?,
                           roomId: Int?) {
        AppConfig.shared.isCurrentUserLoggedIn = true
        if let userId {
            AppConfig.shared.currentUserId = userId
        }
        if let userName {
            AppConfig.shared.currentUserName = userName
        }
        if let roomId {
            AppConfig.shared.currentUserRoomId = roomId
        }
    }
    
    func resetLocalLogInData() {
        AppConfig.shared.isCurrentUserLoggedIn = false
        AppConfig.shared.currentUserId = ""
        AppConfig.shared.currentUserName = ""
        AppConfig.shared.currentUserRoomId = 0
    }
    
    // MARK: - Private
    
    /// カレントユーザーがログイン中か
    private(set) var isCurrentUserLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isCurrentUserLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isCurrentUserLoggedIn")
        }
    }
    
    /// カレントユーザーID
    private(set) var currentUserId: String {
        get {
            UserDefaults.standard.string(forKey: "currentUserId") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentUserId")
        }
    }
    
    /// カレントユーザーの名前
    private(set) var currentUserName: String {
        get {
            UserDefaults.standard.string(forKey: "currentUserName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentUserName")
        }
    }
    
    /// カレントユーザーのログインしているルームID
    private(set) var currentUserRoomId: Int {
        get {
            UserDefaults.standard.integer(forKey: "currentUserRoomId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentUserRoomId")
        }
    }
}
