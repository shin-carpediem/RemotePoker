public protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoomModule() -> EnterRoomView

    /// カードリスト画面をアセンブルする
    /// - parameter roomId: ルームID
    /// - parameter currentUserId: カレントユーザーID
    /// - parameter currentUserName: カレントユーザー名
    /// - parameter cardPackageId: カードパッケージID
    /// - parameter isExisingUser: 既存ユーザーか
    func assembleCardListModule(
        roomId: Int, currentUserId: String, currentUserName: String, cardPackageId: String,
        isExisingUser: Bool
    ) -> CardListView

    /// 設定画面をアセンブルする
    /// - parameter roomId: ルームID
    /// - parameter currentUserId: カレントユーザーID
    /// - parameter cardPackageId: カードパッケージID
    func assembleSettingModule(roomId: Int, currentUserId: String, cardPackageId: String)
        -> SettingView

    /// テーマカラー選択画面をアセンブルする
    /// - parameter roomId: ルームID
    /// - parameter cardPackageId: カードパッケージID
    func assembleSelectThemeColorModule(roomId: Int, cardPackageId: String) -> SelectThemeColorView
}
