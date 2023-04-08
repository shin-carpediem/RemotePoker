import SwiftUI

actor CardListViewModel: CardListObservable {
    // MARK: - CardListObservable

    @MainActor
    @Published var room = RoomViewModel(
        id: 0, userList: [],
        cardPackage: CardPackageModelToCardPackageViewModelTranslator().translate(
            .defaultCardPackage))

    @MainActor
    @Published var title = ""

    @MainActor
    @Published var userSelectStatusList = [UserSelectStatusViewModel]()

    @MainActor
    @Published var isShownSelectedCardList = false

    @MainActor
    var buttonText: String {
        isShownSelectedCardList ? "自分の選択したカードをリセット" : "全員の選択されたカードを見る"
    }

    @MainActor
    var fabIconName: String {
        let selectedCardCount: Int = userSelectStatusList.map { $0.selectedCard }.count
        let systemName: String = {
            if isShownSelectedCardList {
                return "gobackward"
            } else {
                if selectedCardCount >= 3 {
                    return "person.3.sequence"
                } else if selectedCardCount == 2 {
                    return "person.2"
                } else {
                    return "person"
                }
            }
        }()
        return systemName
    }

    @MainActor
    @Published var willPushSettingView = false

    // MARK: - ViewModel

    @MainActor
    @Published var isButtonEnabled = true

    @MainActor
    @Published var isShownLoader = false

    @MainActor
    @Published var isShownBanner = false

    @MainActor
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
}
