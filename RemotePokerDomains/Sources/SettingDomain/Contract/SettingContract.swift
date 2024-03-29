import Foundation
import Protocols

public protocol SettingPresentation: AnyObject, Presentation {
    /// テーマカラー選択画面に遷移するボタンがタップされた
    func didTapSelectThemeColorButton()

    /// ルームから退室するボタンがタップされた
    func didTapLeaveRoomButton() async
}

public protocol SettingUseCase: AnyObject {
    /// ルームから退室する
    func leaveRoom() async
}

public protocol SettingInteractorOutput: AnyObject {
    /// データ処理の成功を出力する
    func outputSuccess(message: String)

    /// エラーを出力する
    func outputError(_ error: Error, message: String)
}
