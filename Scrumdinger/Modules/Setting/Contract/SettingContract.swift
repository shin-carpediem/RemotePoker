protocol SettingPresentation: AnyObject, Presentation {
    /// テーマカラー選択画面に遷移するボタンがタップされた
    func didTapSelectThemeColorButton()
    
    /// ルームから退室するボタンがタップされた
    func didTapLeaveRoomButton()
}

protocol SettingUseCase: AnyObject {
    /// ルームから退室する
    func leaveRoom() async
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
}

protocol SettingInteractorOutput: AnyObject {
    /// データ処理の成功を出力
    func outputSuccess()
    
    /// エラーを出力
    func outputError(_ error: Error)
}
