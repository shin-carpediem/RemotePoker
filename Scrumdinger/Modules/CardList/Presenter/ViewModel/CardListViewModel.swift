import SwiftUI

actor CardListViewModel: CardListObservable {
    // MARK: - ViewModel

    @MainActor @Published var isButtonEnabled = true

    @MainActor @Published var isShownLoader = false

    @MainActor @Published var isShownBanner = false

    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    // MARK: - CardListObservable

    @MainActor @Published var room = Room(id: 0, userList: [], cardPackage: .defaultCardPackage)

    @MainActor @Published var headerTitle = ""

    @MainActor @Published var userSelectStatusList: [UserSelectStatus] = []

    @MainActor @Published var isShownSelectedCardList = false

    @MainActor @Published var willPushSettingView = false
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
