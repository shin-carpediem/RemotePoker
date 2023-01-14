import SwiftUI

actor EnterRoomViewModel: EnterRoomObservable {
    // MARK: - ViewModel

    @MainActor @Published var isButtonEnabled = true

    @MainActor @Published var isShownLoader = false

    @MainActor @Published var isShownBanner = false

    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    // MARK: - EnterRoomObservable

    @MainActor @Published var inputName = ""

    @MainActor @Published var inputRoomId = ""

    @MainActor @Published var isShownEnterCurrentRoomAlert = false

    @MainActor @Published var isShownInputFormInvalidAlert = false

    @MainActor @Published var willPushCardListView = false
}
