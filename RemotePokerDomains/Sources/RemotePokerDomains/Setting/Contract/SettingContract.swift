import Foundation

public protocol SettingPresentation: AnyObject, Presentation {
    /// テーマカラー選択画面に遷移するボタンがタップされた
    func didTapSelectThemeColorButton()

    /// ルームから退室するボタンがタップされた
    func didTapLeaveRoomButton()
}

public protocol SettingUseCase: AnyObject {
    /// ルームから退室する
    func leaveRoom() async
}

public protocol SettingInteractorOutput: AnyObject {
    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
