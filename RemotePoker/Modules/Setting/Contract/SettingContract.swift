import Foundation

protocol SettingObservable: ObservableObject, ViewModel {
    /// テーマカラー選択画面に遷移するか
    @MainActor
    var willPushSelectThemeColorView: Bool { get set }
}

protocol SettingPresentation: AnyObject, Presentation {
    /// テーマカラー選択画面に遷移するボタンがタップされた
    func didTapSelectThemeColorButton()

    /// ルームから退室するボタンがタップされた
    func didTapLeaveRoomButton()
}

protocol SettingUseCase: AnyObject {
    /// ルームから退室する
    func leaveRoom() async
}

protocol SettingInteractorOutput: AnyObject {
    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
