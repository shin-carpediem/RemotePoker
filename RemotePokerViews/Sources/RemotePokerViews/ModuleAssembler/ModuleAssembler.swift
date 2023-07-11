public protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoomModule() -> EnterRoomView

    /// カードリスト画面をアセンブルする
    /// - parameter isExisingUser: 既存ユーザーか
    func assembleCardListModule(isExisingUser: Bool) -> CardListView

    /// 設定画面をアセンブルする
    func assembleSettingModule()
        -> SettingView

    /// テーマカラー選択画面をアセンブルする
    func assembleSelectThemeColorModule() -> SelectThemeColorView
}
