import Foundation
import Protocols
import ViewModel

public class SettingViewModel: ObservableObject, ViewModel {
    public init() {}

    @Published public var willPushSelectThemeColorView = false

    // MARK: - ViewModel

    @Published public var isButtonsEnabled = true
    @Published public var isLoaderShown = false
    @Published public var isBannerShown = false
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
