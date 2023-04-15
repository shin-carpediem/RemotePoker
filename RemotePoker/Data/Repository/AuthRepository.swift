import Combine

public protocol AuthRepository: AnyObject {
    /// ログインする
    /// - returns: ユーザーID
    func signIn() -> Future<String, Never>

    /// ログアウトする
    func signOut() -> Result<Void, FirebaseError>
}
