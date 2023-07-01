import Protocols
import SwiftUI
import Translator
import ViewModel

public actor CardListViewModel: ObservableObject, ViewModel {
    public init() {}

    @MainActor @Published public var room = RoomViewModel(
        id: 0, userList: [],
        cardPackage: CardPackageModelToCardPackageViewModelTranslator().translate(
            .defaultCardPackage))

    @MainActor @Published public var title = ""

    /// ユーザーのカード選択状況一覧
    @MainActor @Published public var userSelectStatusList = [UserSelectStatusViewModel]()

    @MainActor @Published public var isShownSelectedCardList = false

    /// ボタンの説明テキスト
    @MainActor public var buttonText: String {
        isShownSelectedCardList ? "カード選択画面に戻る" : "全員の選択されたカードを見る"
    }

    /// フローティングアクションボタンのシンボル名
    @MainActor public var fabIconName: String {
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

    @MainActor @Published public var willPushSettingView = false

    // MARK: - ViewModel

    @MainActor @Published public var isButtonEnabled = true

    @MainActor @Published public var isShownLoader = false

    @MainActor @Published public var isShownBanner = false

    @MainActor @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
