public struct CardPackageModel {
    public var id: String
    public var themeColor: String
    public var cardList: [Card]

    public struct Card {
        public var id: String
        public var estimatePoint: String
        public var index: Int

        public init(id: String, estimatePoint: String, index: Int) {
            self.id = id
            self.estimatePoint = estimatePoint
            self.index = index
        }
    }

    public init(id: String, themeColor: String, cardList: [Card]) {
        self.id = id
        self.themeColor = themeColor
        self.cardList = cardList
    }
}
