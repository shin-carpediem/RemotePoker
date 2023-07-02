import Foundation
import Protocols
import ViewModel

public class SettingViewModel: ObservableObject, ViewModel {
    public init() {}

    @Published public var willPushSelectThemeColorView = false

    // MARK: - ViewModel

    @Published public var isButtonEnabled = true
    @Published public var isShownLoader = false
    @Published public var isShownBanner = false
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
