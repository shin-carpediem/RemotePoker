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
            UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
        }
    }
}
