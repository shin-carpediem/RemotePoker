import SwiftUI

public actor CardListViewModel: ObservableObject, ViewModel {
    public init() {}

    /// ルーム
    @MainActor
    @Published public var room = RoomViewModel(
        id: 0, userList: [],
        cardPackage: CardPackageModelToCardPackageViewModelTranslator().translate(
            .defaultCardPackage))

    /// タイトル
    @MainActor
    @Published public var title = ""

    /// ユーザーのカード選択状況一覧
    @MainActor
    @Published public var userSelectStatusList = [UserSelectStatusViewModel]()

    /// 選択済みカード一覧が公開されるか
    @MainActor
    @Published public var isShownSelectedCardList = false

    /// ボタンの説明テキスト
    @MainActor
    public var buttonText: String {
        isShownSelectedCardList ? "自分の選択したカードをリセット" : "全員の選択されたカードを見る"
    }

    /// フローティングアクションボタンのシンボル名
    @MainActor
    public var fabIconName: String {
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

    /// 設定画面に遷移するか
    @MainActor
    @Published public var willPushSettingView = false

    // MARK: - ViewModel

    @MainActor
    @Published public var isButtonEnabled = true

    @MainActor
    @Published public var isShownLoader = false

    @MainActor
    @Published public var isShownBanner = false

    @MainActor
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
