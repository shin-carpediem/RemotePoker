import Foundation
import Protocols
import ViewModel

public actor SettingViewModel: ObservableObject, ViewModel {
    public init() {}

    @MainActor @Published public var willPushSelectThemeColorView = false

    // MARK: - ViewModel

    @MainActor @Published public var isButtonEnabled = true

    @MainActor @Published public var isShownLoader = false

    @MainActor @Published public var isShownBanner = false

    @MainActor @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
