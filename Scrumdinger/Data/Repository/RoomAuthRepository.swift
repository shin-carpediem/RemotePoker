protocol RoomAuthRepository: AnyObject {
    /// 共有インスタンス
    static var shared: RoomAuthDataStore { get }

    /// ログインしているか
    var isUsrLoggedIn: Bool { get }

    /// ユーザーIDを取得する
    /// - returns: ユーザーID
    func fetchUserId() -> String?

    /// 認証状況を購読する
    func subscribeAuth()

    /// 認証状況の購読を解除する
    func unsubscribeAuth() -> Result<Void, RoomAuthError>

    /// ログインする
    /// - returns  ユーザーID
    func login(completion: @escaping (Result<String, RoomAuthError>) -> Void)

    /// ログアウトする
    func logout() -> Result<Void, RoomAuthError>
}

enum RoomAuthError: Error {
    /// 認証状況の購読解除に失敗した
    case failedToUnsubscibeAuth

    /// ログインに失敗した
    case failedToLogin

    /// ログアウトに失敗した
    case failedToLogout
}
