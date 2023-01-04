protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoom() -> EnterRoomView
    
    /// カードリスト画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter currentUser: カレントユーザー
    func assembleCardList(room: Room, currentUser: User) -> CardListView
    
    /// 設定画面をアセンブルする
    /// - parameter room: ルーム
    /// - parameter currentUser: カレントユーザー
    func assembleSetting(room: Room, currentUser: User) -> SettingView
    
    /// テーマカラー選択画面をアセンブルする
    /// - parameter room: ルーム
    func assembleSelectThemeColor(room: Room) -> SelectThemeColorView
}
