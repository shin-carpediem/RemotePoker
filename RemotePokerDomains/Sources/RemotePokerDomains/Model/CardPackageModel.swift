struct CardPackageModel {
    /// ID
    var id: String

    /// テーマカラー
    var themeColor: String

    /// カード一覧
    var cardList: [Card]

    struct Card {
        /// ID
        var id: String

        /// 見積もりポイント
        var point: String

        /// インデックス
        var index: Int
    }
}
