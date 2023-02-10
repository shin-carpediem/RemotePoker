import Foundation

protocol SelectThemeColorObservable: ObservableObject, ViewModel {
    /// テーマカラー一覧
    @MainActor
    var themeColorList: [CardPackage.ThemeColor] { get set }

    /// 選択されたテーマカラー
    @MainActor
    var selectedThemeColor: CardPackage.ThemeColor? { get set }
}

protocol SelectThemeColorPresentation: AnyObject, Presentation {
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: CardPackage.ThemeColor)
}

protocol SelectThemeColorUseCase: AnyObject {
    /// テーマカラーを変更する
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(themeColor: CardPackage.ThemeColor)
}

protocol SelectThemeColorInteractorOutput: AnyObject {
    /// 選択せれたテーマカラーを出力
    @MainActor
    func outputSelectedThemeColor(_ themeColor: CardPackage.ThemeColor)

    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
