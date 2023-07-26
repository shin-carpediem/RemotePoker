import Combine

public protocol AuthRepository: AnyObject {
    /// サインインする
    /// - returns: ユーザーID
    func signIn() -> Future<String, FirebaseError>

    /// サインアウトする
    func signOut() -> Result<Void, FirebaseError>
}
