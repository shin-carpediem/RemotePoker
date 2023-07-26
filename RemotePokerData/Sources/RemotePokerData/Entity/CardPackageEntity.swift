public struct CardPackageEntity {
    public var id: Int
    public var themeColor: String
    public var cardList: [Card]

    public struct Card {
        public var id: Int
        public var estimatePoint: String
        public var index: Int

        public init(id: Int, estimatePoint: String, index: Int) {
            self.id = id
            self.estimatePoint = estimatePoint
            self.index = index
        }
    }

    public init(id: Int, themeColor: String, cardList: [Card]) {
        self.id = id
        self.themeColor = themeColor
        self.cardList = cardList
    }
}
