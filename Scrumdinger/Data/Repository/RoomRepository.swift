protocol RoomRepository: AnyObject {
    /// ルームを取得する
    /// - returns: 成功ならルーム
    func fetchRoom() async -> Result<Room, FirebaseError>

    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func addUserToRoom(user: User) async -> Result<Void, FirebaseError>

    /// ルームからユーザーを削除する
    /// - parameter userId: ユーザーID
    func removeUserFromRoom(userId: String) async -> Result<Void, FirebaseError>

    /// ユーザーを購読する
    /// - parameter completion: 完了ハンドラ(ドキュメント操作の種類を返却)
    func subscribeUser(
        completion: @escaping (Result<FireStoreDocumentChanges, FirebaseError>) -> Void)

    /// ユーザーの購読を解除する
    func unsubscribeUser()

    /// カードパッケージを購読する
    /// - parameter completion: 完了ハンドラ(ドキュメント操作の種類を返却)
    func subscribeCardPackage(
        completion: @escaping (Result<FireStoreDocumentChanges, FirebaseError>) -> Void)

    /// カードパッケージの購読を解除する
    func unsubscribeCardPackage()

    /// 指定IDのユーザーを取得する
    /// - parameter id: ユーザーID
    /// - parameter completion: 完了ハンドラ(ユーザーを返却)
    func fetchUser(id: String, completion: @escaping (User) -> Void)

    /// ユーザーの選択済みカードを更新する
    /// - parameter selectedCardDictionary: ユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])

    /// テーマカラーを変更する
    /// - parameter cardPackageId: カードパッケージID
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(cardPackageId: String, themeColor: ThemeColor)
}
