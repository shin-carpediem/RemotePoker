protocol RoomAuthRepository {
    /// ログインしているか
    /// - returns ログインしているか
    func isUserLogin() -> Bool
    
    /// ログインする
    /// - returns ユーザーID(nilならログイン失敗)
    func login() -> String?
    
    /// ログアウトする
    /// - returns 成功したか
    func logout() -> Bool
}
