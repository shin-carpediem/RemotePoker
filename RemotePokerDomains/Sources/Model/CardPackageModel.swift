public struct CardPackageModel {
    public var id: String
    public var themeColor: String
    public var cardList: [Card]

    public struct Card {
        public var id: String
        /// 見積もりポイント
        public var point: String
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
