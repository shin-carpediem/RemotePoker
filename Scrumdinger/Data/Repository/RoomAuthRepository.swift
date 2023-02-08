protocol RoomAuthRepository: AnyObject {
    /// ログインする
    /// - parameter completion: 完了ハンドラ(ユーザーIDを返却)
    func login(completion: @escaping (Result<String, FirebaseError>) -> Void)

    /// ログアウトする
    func logout() -> Result<Void, FirebaseError>
}
