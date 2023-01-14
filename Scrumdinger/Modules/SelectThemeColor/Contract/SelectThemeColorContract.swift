protocol SelectThemeColorPresentation: Presentation {
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: ThemeColor)
}

protocol SelectThemeColorUseCase: AnyObject {
    /// テーマカラーを変更する
    /// - parameter themeColor: テーマカラー
    func updateThemeColor(themeColor: ThemeColor)
}

protocol SelectThemeColorInteractorOutput: AnyObject {
    /// 選択せれたテーマカラーを出力
    @MainActor func outputSelectedThemeColor(_ themeColor: ThemeColor)

    /// データ処理の成功を出力
    @MainActor func outputSuccess(message: String)

    /// エラーを出力
    @MainActor func outputError(_ error: Error, message: String)
}
