protocol RoomAuthRepository: AnyObject {
    /// ログインする
    /// - returns  ユーザーID
    func login(completion: @escaping (Result<String, FirebaseError>) -> Void)

    /// ログアウトする
    func logout() -> Result<Void, FirebaseError>
}
