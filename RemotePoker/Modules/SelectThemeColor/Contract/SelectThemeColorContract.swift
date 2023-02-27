import Foundation

protocol SelectThemeColorObservable: ObservableObject, ViewModel {
    /// テーマカラー一覧
    @MainActor
    var themeColorList: [CardPackageThemeColor] { get set }

    /// 選択されたテーマカラー
    @MainActor
    var selectedThemeColor: CardPackageThemeColor? { get set }
}

protocol SelectThemeColorPresentation: AnyObject, Presentation {
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: CardPackageThemeColor)
}

protocol SelectThemeColorUseCase: AnyObject {
    /// テーマカラーを変更する
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(themeColor: CardPackageThemeColor)
}

protocol SelectThemeColorInteractorOutput: AnyObject {
    /// 選択せれたテーマカラーを出力
    @MainActor
    func outputSelectedThemeColor(_ themeColor: CardPackageThemeColor)

    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
