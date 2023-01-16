protocol RoomAuthRepository: AnyObject {
    /// 共有インスタンス
    static var shared: RoomAuthDataStore { get }

    /// ユーザーIDを取得する
    /// - returns: ユーザーID
    func fetchUserId() -> String?

    /// ログインしているか
    /// - returns: ログインしているか
    func isUserLoggedIn(completion: @escaping (Bool) -> Void)

    /// ログインする
    /// - returns  ユーザーID
    func login(completion: @escaping (Result<String, RoomAuthError>) -> Void)

    /// ログアウトする
    func logout() -> Result<Void, RoomAuthError>
}

enum RoomAuthError: Error {
    /// ログインに失敗した
    case failedToLogin

    /// ログアウトに失敗した
    case failedToLogout
}
