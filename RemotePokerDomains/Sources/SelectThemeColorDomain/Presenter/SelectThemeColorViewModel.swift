import Foundation
import Protocols
import ViewModel

public class SelectThemeColorViewModel: ObservableObject, ViewModel {
    public init() {}

    @Published public var themeColorList = [CardPackageThemeColor]()

    @Published public var selectedThemeColor: CardPackageThemeColor?

    // MARK: - ViewModel

    @Published public var isButtonsEnabled = true
    @Published public var isLoaderShown = false
    @Published public var isBannerShown = false
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")
}
