import Foundation

class AppConfig {
    class var shared: AppConfig {
        struct Static {
            static let instance: AppConfig = .init()
        }
        return Static.instance
    }
    
    /// カレントユーザーにローカルデータを追加する
    func addLocalLogInData(userId: String,
                           userName: String,
                           roomId: Int) {
        AppConfig.shared.currentUserId = userId
        AppConfig.shared.currentUserName = userName
        AppConfig.shared.currentUserRoomId = roomId
    }
    
    /// カレントユーザーからローカルデータをリセットする
    func resetLocalLogInData() {
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
