enum RoomAuthError: Error {
    /// ログインに失敗した
    case failedToLogin
    
    /// ログアウトに失敗した
    case failedToLogout
}

protocol RoomAuthDelegate: AnyObject {
    /// ログインに成功した時
    /// - parameter ユーザーID
    func whenSuccessLogin(userId: String)
    
    /// ログインに失敗した時
    /// - parameter error: エラー
    func whenFailedToLogin(error: RoomAuthError)
}

protocol RoomAuthRepository: AnyObject {
    /// 共有インスタンス
    static var shared: RoomAuthDataStore { get }
    
    /// デリゲート
    var delegate: RoomAuthDelegate? { get set }
    
    /// ユーザーIDを取得する
    /// - returns: ユーザーID
    func fetchUserId() -> String?
    
    /// ログインしているか
    /// - returns: ログインしているか
    func isUserLoggedIn() -> Bool
    
    /// ログインする
    func login()
    
    /// ログアウトする
    func logout() -> Result<Void, RoomAuthError>
}
