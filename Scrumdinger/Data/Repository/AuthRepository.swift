import Combine

protocol AuthRepository: AnyObject {
    /// ログインする
    /// - returns: ユーザーID
    func login() -> Future<String, Never>

    /// ログアウトする
    func logout() -> Result<Void, FirebaseError>
}
