import Foundation
import Protocols
import ViewModel

public actor SelectThemeColorViewModel: ObservableObject, ViewModel {
    public init() {}

    @MainActor @Published public var themeColorList = [CardPackageThemeColor]()

    @MainActor @Published public var selectedThemeColor: CardPackageThemeColor?

    // MARK: - ViewModel

    @MainActor @Published public var isButtonEnabled = true

    @MainActor @Published public var isShownLoader = false

    @MainActor @Published public var isShownBanner = false

    @MainActor @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
