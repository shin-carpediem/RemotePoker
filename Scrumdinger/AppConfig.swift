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
    
    /// カレントユーザーのID
    var currentUserId: String {
        get {
            UserDefaults.standard.string(forKey: "currentUserId") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentUserId")
        }
    }
    
    /// カレントユーザーのログインしているルームID
    var currentUserRoomId: Int {
        get {
            UserDefaults.standard.integer(forKey: "currentUserRoomId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentUserRoomId")
        }
    }
    
    func resetLocalLogInData() {
        AppConfig.shared.isCurrentUserLoggedIn = false
        AppConfig.shared.currentUserId = ""
        AppConfig.shared.currentUserRoomId = 0
    }
}
