import Foundation

protocol SelectThemeColorObservable: ObservableObject, ViewModel {
    /// テーマカラー一覧
    @MainActor
    var themeColorList: [CardPackageEntity.ThemeColor] { get set }

    /// 選択されたテーマカラー
    @MainActor
    var selectedThemeColor: CardPackageEntity.ThemeColor? { get set }
}

protocol SelectThemeColorPresentation: AnyObject, Presentation {
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: CardPackageEntity.ThemeColor)
}

protocol SelectThemeColorUseCase: AnyObject {
    /// テーマカラーを変更する
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(themeColor: CardPackageEntity.ThemeColor)
}

protocol SelectThemeColorInteractorOutput: AnyObject {
    /// 選択せれたテーマカラーを出力
    @MainActor
    func outputSelectedThemeColor(_ themeColor: CardPackageEntity.ThemeColor)

    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
