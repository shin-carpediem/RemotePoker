import Foundation
import Protocols
import ViewModel

public class SelectThemeColorViewModel: ObservableObject, ViewModel {
    public init() {}

    @Published public var themeColorList = [CardPackageThemeColor]()

    @Published public var selectedThemeColor: CardPackageThemeColor?

    // MARK: - ViewModel

    @Published public var isButtonEnabled = true
    @Published public var isShownLoader = false
    @Published public var isShownBanner = false
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
