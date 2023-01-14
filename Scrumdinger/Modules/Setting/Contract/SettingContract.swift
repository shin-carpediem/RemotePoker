import Foundation

protocol SettingObservable: ObservableObject, ViewModel {
    /// テーマカラー選択画面に遷移するか
    @MainActor var willPushSelectThemeColorView: Bool { get set }
}

protocol SettingPresentation: Presentation {
    /// テーマカラー選択画面に遷移するボタンがタップされた
    func didTapSelectThemeColorButton()

    /// ルームから退室するボタンがタップされた
    func didTapLeaveRoomButton()
}

protocol SettingUseCase: AnyObject {
    /// ルームから退室する
    func leaveRoom() async

    /// ルームIDを必要とするルームリポジトリを無効にする
    func disposeRoomRepository()

    /// ユーザーの購読を解除する
    func unsubscribeUser()

    /// カードパッケージの購読を解除する
    func unsubscribeCardPackages()
}

protocol SettingInteractorOutput: AnyObject {
    /// データ処理の成功を出力
    @MainActor func outputSuccess(message: String)

    /// エラーを出力
    @MainActor func outputError(_ error: Error, message: String)
}
