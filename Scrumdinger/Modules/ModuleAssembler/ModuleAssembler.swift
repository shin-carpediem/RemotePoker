protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoom() -> EnterRoomView
    
    /// カードリスト画面をアセンブルする
    /// - parameter roomId: ルームID
    /// - parameter currentUserId: カレントユーザーID
    /// - parameter currentUserName: カレントユーザー名
    /// - parameter cardPackageId: カードパッケージID
    func assembleCardList(roomId: Int, currentUserId: String, currentUserName: String, cardPackageId: String) -> CardListView
    
    /// 設定画面をアセンブルする
    /// - parameter roomId: ルームID
    /// - parameter currentUserId: カレントユーザーID
    /// - parameter cardPackageId: カードパッケージID
    func assembleSetting(roomId: Int, currentUserId: String, cardPackageId: String) -> SettingView
    
    /// テーマカラー選択画面をアセンブルする
    /// - parameter roomId: ルームID
    /// - parameter cardPackageId: カードパッケージID
    func assembleSelectThemeColor(roomId: Int, cardPackageId: String) -> SelectThemeColorView
}
