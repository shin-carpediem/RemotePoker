public struct UserSelectStatusViewModel: Identifiable {
    public var id: String
    public var user: UserViewModel
    public var themeColor: CardPackageThemeColor
    public var selectedCard: CardPackageViewModel.Card?

    public init(
        id: String, user: UserViewModel, themeColor: CardPackageThemeColor,
        selectedCard: CardPackageViewModel.Card? = nil
    ) {
        self.id = id
        self.user = user
        self.themeColor = themeColor
        self.selectedCard = selectedCard
    }
}
