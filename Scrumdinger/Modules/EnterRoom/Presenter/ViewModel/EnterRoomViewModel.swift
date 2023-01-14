import Combine
import SwiftUI

final class EnterRoomViewModel: EnterRoomObservable {
    init() {
        subscribeInputForm()
    }

    deinit {
        unsubscribeInputForm()
    }

    // MARK: - ViewModel

    @MainActor @Published var isButtonEnabled = true

    @MainActor @Published var isShownLoader = false

    @MainActor @Published var isShownBanner = false

    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    // MARK: - EnterRoomObservable

    @MainActor @Published var inputName = ""

    @MainActor @Published var inputRoomId = ""

    @MainActor @Published private(set) var isInputFormValid = true

    @MainActor var inputFormvalidatedMessage: String {
        isInputFormValid ? "数字が新しければ新しいルームが作られます" : "名前と4桁の数字が必要です"
    }

    @MainActor @Published var isShownEnterCurrentRoomAlert = false

    @MainActor @Published var willPushCardListView = false

    // MARK: - Private

    private var subscriptions: Set<AnyCancellable> = []

    /// 入力フォーム内容を購読する
    private func subscribeInputForm() {
        Task {
            $inputName
                .combineLatest($inputRoomId)
                .receive(on: DispatchQueue.main)
                .map { [weak self] inputName, inputRoomId -> Bool in
                    if let self = self {
                        return self.isInputNameValid(inputName)
                            && self.isInputRoomIdValid(inputRoomId)
                    } else {
                        return false
                    }
                }
                .assign(to: \.isInputFormValid, on: self)
                .store(in: &subscriptions)
        }
    }

    /// 入力フォーム/名前が有効か
    private func isInputNameValid(_ name: String) -> Bool {
        !name.isEmpty
    }

    /// 入力フォーム/ルームIDが有効か
    private func isInputRoomIdValid(_ roomId: String) -> Bool {
        if let inputInt = Int(roomId) {
            return String(inputInt).count == 4
        } else {
            return false
        }
    }

    /// 入力フォーム内容の購読を解除する
    private func unsubscribeInputForm() {
        subscriptions.forEach { subscription in
            subscription.cancel()
        }
    }
}
