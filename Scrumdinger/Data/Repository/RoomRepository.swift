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
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID
    /// - returns: 存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(_ room: Room) async -> Result<Void, RoomError>

    /// ルームを取得する
    /// - returns: ルーム
    func fetchRoom() async -> Result<Room, RoomError>

    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func addUserToRoom(user: User) async -> Result<Void, RoomError>

    /// ルームからユーザーを削除する
    /// - parameter userId: ユーザーID
    func removeUserFromRoom(userId: String) async -> Result<Void, RoomError>

    /// ユーザーを購読する
    /// - returns: ユーザーへのCRUOの種類
    func subscribeUser(completion: @escaping (Result<UserAction, RoomError>) -> Void)

    /// ユーザーの購読を解除する
    func unsubscribeUser()

    /// カードパッケージを購読する
    /// - returns: カードパッケージへのCRUDの種類
    func subscribeCardPackage(completion: @escaping (Result<CardPackageAction, RoomError>) -> Void)

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

enum RoomError: Error {
    /// ルームの新規作成に失敗した時
    case failedToCreateRoom

    /// ルームの取得に失敗した時
    case failedToFetchRoom

    /// ルームへのユーザー追加に失敗した時
    case failedToAddUserToRoom

    /// ルームからの退出に失敗した時
    case failedToRemoveUserFromRoom

    /// ユーザーの購読に失敗した時
    case failedToSubscribeUser

    /// 指定IDのユーザー取得に失敗した時
    case failedToFetchUser

    /// カードパッケージの購読に失敗した時
    case failedToSubscribeCardPackage
}
