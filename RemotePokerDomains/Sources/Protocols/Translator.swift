public protocol Translator {
    /// 入力する型
    associatedtype Input
    /// 出力する型
    associatedtype Output

    /// 型変換する
    /// - parameter input: 入力する型
    func translate(from input: Input) -> Output
}
