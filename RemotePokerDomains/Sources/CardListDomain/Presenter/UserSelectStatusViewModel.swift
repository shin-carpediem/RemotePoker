import ViewModel

public struct UserSelectStatusViewModel: Identifiable {
    public var id: Int
    public var user: UserViewModel
    public var themeColor: CardPackageThemeColor
    public var selectedCard: CardPackageViewModel.Card?

    public init(
        id: Int, user: UserViewModel, themeColor: CardPackageThemeColor,
        selectedCard: CardPackageViewModel.Card?
    ) {
        self.id = id
        self.user = user
        self.themeColor = themeColor
        self.selectedCard = selectedCard
    }
}
