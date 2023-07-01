import Foundation
import Protocols

public protocol SettingPresentation: AnyObject, Presentation {
    /// テーマカラー選択画面に遷移するボタンがタップされた
    func didTapSelectThemeColorButton()
}

public protocol SettingInteractorOutput: AnyObject {
    /// データ処理の成功を出力
    @MainActor func outputSuccess(message: String)

    /// エラーを出力
    @MainActor func outputError(_ error: Error, message: String)
}
