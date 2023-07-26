import Protocols
import SwiftUI
import Translator
import ViewModel

public class CardListViewModel: ObservableObject, ViewModel {
    public init() {}

    @Published public var room = CurrentRoomViewModel(
        id: 0, userList: [UserViewModel](),
        cardPackage: CardPackageModelToViewModelTranslator().translate(
            from: .defaultCardPackage))

    @Published public var title = ""

    @Published public var userSelectStatusList = [UserSelectStatusViewModel]()

    @Published public var isSelectedCardListShown = false

    @Published public var willPushSettingView = false

    // MARK: ViewModel

    @Published public var isButtonsEnabled = true
    @Published public var isLoaderShown = false
    @Published public var isBannerShown = false
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
