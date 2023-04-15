import SwiftUI

actor CardListViewModel: ObservableObject, ViewModel {
    /// ルーム
    @MainActor
    @Published var room = RoomViewModel(
        id: 0, userList: [],
        cardPackage: CardPackageModelToCardPackageViewModelTranslator().translate(
            .defaultCardPackage))

    /// タイトル
    @MainActor
    @Published var title = ""

    /// ユーザーのカード選択状況一覧
    @MainActor
    @Published var userSelectStatusList = [UserSelectStatusViewModel]()

    /// 選択済みカード一覧が公開されるか
    @MainActor
    @Published var isShownSelectedCardList = false

    /// ボタンの説明テキスト
    @MainActor
    var buttonText: String {
        isShownSelectedCardList ? "自分の選択したカードをリセット" : "全員の選択されたカードを見る"
    }

    /// フローティングアクションボタンのシンボル名
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

    /// 設定画面に遷移するか
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
