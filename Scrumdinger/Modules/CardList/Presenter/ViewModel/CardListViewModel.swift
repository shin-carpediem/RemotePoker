import SwiftUI

actor CardListViewModel: CardListObservable {
    // MARK: - CardListObservable

    @MainActor
    @Published var isButtonEnabled = true

    @MainActor
    @Published var isShownLoader = false

    @MainActor
    @Published var isShownBanner = false

    @MainActor
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    @MainActor
    @Published var room = Room(id: 0, userList: [], cardPackage: .defaultCardPackage)

    @MainActor
    @Published var headerTitle = ""

    @MainActor
    @Published var userSelectStatusList: [UserSelectStatus] = []

    @MainActor
    @Published var isShownSelectedCardList = false

    @MainActor
    @Published var willPushSettingView = false

    @MainActor
    lazy var fabIconName: String = {
        let selectedCardCount = userSelectStatusList.map { $0.selectedCard }.count
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
    }()
}

struct UserSelectStatus: Identifiable {
    /// ID
    var id: Int

    /// ユーザー
    var user: User

    /// テーマカラー
    var themeColor: ThemeColor

    /// 選択済みカード
    var selectedCard: Card?
}
