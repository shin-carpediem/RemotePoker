import Protocols
import SwiftUI
import Translator
import ViewModel

public class CardListViewModel: ObservableObject, ViewModel {
    public init() {}

    @Published public var room = RoomViewModel(
        id: 0, userList: [],
        cardPackage: CardPackageModelToCardPackageViewModelTranslator().translate(
            .defaultCardPackage))

    @Published public var title = ""

    @Published public var userSelectStatusList = [UserSelectStatusViewModel]()

    @Published public var isShownSelectedCardList = false

    /// ボタンの説明テキスト
    public var buttonText: String {
        isShownSelectedCardList ? "カード選択画面に戻る" : "全員の選択されたカードを見る"
    }

    /// フローティングアクションボタンのシンボル名
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

    @Published public var willPushSettingView = false

    // MARK: - ViewModel

    @Published public var isButtonEnabled = true
    @Published public var isShownLoader = false
    @Published public var isShownBanner = false
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
