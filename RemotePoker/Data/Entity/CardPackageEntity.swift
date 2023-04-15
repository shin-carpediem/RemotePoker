public struct CardPackageEntity {
    /// ID
    public var id: String

    /// テーマカラー
    public var themeColor: String

    /// カード一覧
    public var cardList: [Card]

    /// カード
    public struct Card {
        /// ID
        public var id: String

        /// 見積もりポイント
        public var point: String

        /// インデックス
        public var index: Int
        
        public init(id: String, point: String, index: Int) {
            self.id = id
            self.point = point
            self.index = index
        }
    }
    
    public init(id: String, themeColor: String, cardList: [Card]) {
        self.id = id
        self.themeColor = themeColor
        self.cardList = cardList
    }
}
