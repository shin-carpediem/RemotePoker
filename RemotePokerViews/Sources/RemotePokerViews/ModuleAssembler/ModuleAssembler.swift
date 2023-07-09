public protocol ModuleAssembler {
    /// ルームに入る画面をアセンブルする
    func assmebleEnterRoomModule() -> EnterRoomView

    /// カードリスト画面をアセンブルする
    /// - parameter cardPackageId: カードパッケージID
    /// - parameter isExisingUser: 既存ユーザーか
    func assembleCardListModule(cardPackageId: String, isExisingUser: Bool
    ) -> CardListView

    /// 設定画面をアセンブルする
    /// - parameter cardPackageId: カードパッケージID
    func assembleSettingModule(cardPackageId: String)
        -> SettingView

    /// テーマカラー選択画面をアセンブルする
    /// - parameter cardPackageId: カードパッケージID
    func assembleSelectThemeColorModule(cardPackageId: String) -> SelectThemeColorView
}
