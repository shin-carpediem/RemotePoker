protocol SettingPresentation {
    /// テーマカラー選択画面に遷移するボタンがタップされた
    func didTapSelectThemeColorButton()
    
    /// ルームから退室するボタンがタップされた
    func didTapLeaveRoomButton()
}

protocol SettingUseCase {
    /// ルームから退室する
    func leaveRoom() async
    
    /// ユーザーの購読を解除する
    func unsubscribeUser()
}
