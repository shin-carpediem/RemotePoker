import Combine

protocol RoomRepository: AnyObject {
    /// ユーザーリスト
    var userList: PassthroughSubject<[UserEntity], Never> { get }

    /// カードパッケージ
    var cardPackage: PassthroughSubject<CardPackageEntity, Never> { get }

    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func addUserToRoom(user: UserEntity) async -> Result<Void, FirebaseError>

    /// ルームからユーザーを削除する
    /// - parameter userId: ユーザーID
    func removeUserFromRoom(userId: String) async -> Result<Void, FirebaseError>

    /// 指定IDのユーザーを取得する
    /// - parameter byId: ユーザーID
    /// - returns: ユーザーを返却
    func fetchUser(byId id: String) -> Future<UserEntity, Never>

    /// ユーザーの選択済みカードを更新する
    /// - parameter selectedCardDictionary: ユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])

    /// テーマカラーを変更する
    /// - parameter cardPackageId: カードパッケージID
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(cardPackageId: String, themeColor: CardPackageEntity.ThemeColor)

    /// ユーザーの購読を解除する
    func unsubscribeUser()

    /// カードパッケージの購読を解除する
    func unsubscribeCardPackage()
}
