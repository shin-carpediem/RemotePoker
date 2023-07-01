import Combine
import Protocols
import SwiftUI
import ViewModel

public final class EnterRoomViewModel: ObservableObject, ViewModel {
    public init() {
        observeInputForm()
    }

    @MainActor @Published public var inputName = ""

    @MainActor @Published public var inputRoomId = ""

    @MainActor @Published public private(set) var isInputFormValid = true

    /// 入力フォーム内容が有効か評価されて表示されるメッセージ
    @MainActor public var inputFormvalidatedMessage: String {
        isInputFormValid ? "数字が新しければ新しいルームが作られます" : "6文字以下の名前と4桁の数字が必要です"
    }

    @MainActor @Published public var willPushCardListView = false

    // MARK: - ViewModel

    @MainActor @Published public var isButtonEnabled = true

    @MainActor @Published public var isShownLoader = false

    @MainActor @Published public var isShownBanner = false

    @MainActor @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")

    // MARK: - Private

    private var cancellables = Set<AnyCancellable>()

    private func observeInputForm() {
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
            .store(in: &cancellables)
    }

    private func isInputNameValid(_ name: String) -> Bool {
        !name.isEmpty && name.count <= 6
    }

    private func isInputRoomIdValid(_ roomId: String) -> Bool {
        let validRoomIdLength = 4
        if let inputInt = Int(roomId) {
            return String(inputInt).count == validRoomIdLength
        } else {
            return false
        }
    }
}
