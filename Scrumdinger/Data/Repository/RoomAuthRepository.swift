protocol RoomAuthRepository {
    /// ログインしているか
    /// - returns ログインしているか
    func isUserLogin() -> Bool
    
    /// ログインする
    func login()
    
    /// ログアウトする
    /// - returns 成功したか
    func logout() -> Bool
}
