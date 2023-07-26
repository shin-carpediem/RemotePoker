import Combine

public protocol CurrentRoomRepository: AnyObject {
    /// ユーザー一覧
    var userList: PassthroughSubject<[UserEntity], Never> { get }
    
    /// ルーム
    var room: PassthroughSubject<RoomEntity, Never> { get }

    /// ルームにユーザーを追加する
    func addUserToRoom() async -> Result<Void, FirebaseError>

    /// ルームからユーザーを削除する
    func removeUserFromRoom() async -> Result<Void, FirebaseError>

    /// ユーザーを取得する
    /// - returns: ユーザー
    func fetchUser() -> Future<UserEntity, FirebaseError>

    /// ユーザーの選択済みカードを更新する
    /// - parameter selectedCardDictionary: ユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: Int])

    /// テーマカラーを変更する
    /// - parameter cardPackageId: カードパッケージID
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(cardPackageId: String, themeColor: String)

    /// ユーザー一覧の購読を中止する
    func unsubscribeUserList()
    
    /// ルームの購読を中止する
    func unsubscribeRoom()
}
