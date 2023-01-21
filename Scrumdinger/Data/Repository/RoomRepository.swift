enum UserAction {
    /// ユーザーが追加された時
    case added
    /// ユーザーが更新された時
    case modified
    /// ユーザーが削除された時
    case removed
}

enum CardPackageAction {
    /// カードパッケージが追加された時
    case added
    /// カードパッケージが更新された時
    case modified
    /// カードパッケージが削除された時
    case removed
}

protocol RoomRepository: AnyObject {
    /// ルームを取得する
    /// - returns: ルーム
    func fetchRoom() async -> Result<Room, FirebaseError>

    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func addUserToRoom(user: User) async -> Result<Void, FirebaseError>

    /// ルームからユーザーを削除する
    /// - parameter userId: ユーザーID
    func removeUserFromRoom(userId: String) async -> Result<Void, FirebaseError>

    /// ユーザーを購読する
    /// - returns: ユーザーへのCRUOの種類
    func subscribeUser(completion: @escaping (Result<UserAction, FirebaseError>) -> Void)

    /// ユーザーの購読を解除する
    func unsubscribeUser()

    /// カードパッケージを購読する
    /// - returns: カードパッケージへのCRUDの種類
    func subscribeCardPackage(
        completion: @escaping (Result<CardPackageAction, FirebaseError>) -> Void)

    /// カードパッケージの購読を解除する
    func unsubscribeCardPackage()

    /// 指定IDのユーザーを取得する
    /// - parameter id: ユーザーID
    /// - returns: ユーザー
    func fetchUser(id: String, completion: @escaping (User) -> Void)

    /// ユーザーの選択済みカードを更新する
    /// - parameter selectedCardDictionary: ユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])

    /// テーマカラーを変更する
    /// - parameter cardPackageId: カードパッケージID
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(cardPackageId: String, themeColor: ThemeColor)
}
