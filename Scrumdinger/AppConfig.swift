import Foundation

class AppConfig {
    class var shared: AppConfig {
        struct Static {
            static let instance: AppConfig = .init()
        }
        return Static.instance
    }
        
    /// カレントユーザーがログイン中か
    var isCurrentUserLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isCurrentUserLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isCurrentUserLoggedIn")
        }
    }
    
    func addLocalLogInData(userId: String,
                           userName: String,
                           roomId: Int) {
        AppConfig.shared.isCurrentUserLoggedIn = true
        AppConfig.shared.currentUserId = userId
        AppConfig.shared.currentUserName = userName
        AppConfig.shared.currentUserRoomId = roomId
    }
    
    func resetLocalLogInData() {
        AppConfig.shared.isCurrentUserLoggedIn = false
        AppConfig.shared.currentUserId = ""
        AppConfig.shared.currentUserName = ""
        AppConfig.shared.currentUserRoomId = 0
    }
    
    // MARK: - Private

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
