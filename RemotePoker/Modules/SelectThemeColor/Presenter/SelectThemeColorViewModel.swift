import Foundation
import RemotePokerViews

actor SelectThemeColorViewModel: ObservableObject, ViewModel {
    /// テーマカラー一覧
    @MainActor
    @Published var themeColorList = [CardPackageThemeColor]()

    /// 選択されたテーマカラー
    @MainActor
    @Published var selectedThemeColor: CardPackageThemeColor?

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
