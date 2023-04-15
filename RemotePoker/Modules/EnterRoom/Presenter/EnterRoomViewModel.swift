import Combine
import RemotePokerViews
import SwiftUI

final class EnterRoomViewModel: ObservableObject, ViewModel {
    init() {
        observeInputForm()
    }

    deinit {
        disposeInputForm()
    }

    /// 入力フォーム/名前
    @MainActor
    @Published var inputName = ""

    /// 入力フォーム/ルームID
    @MainActor
    @Published var inputRoomId = ""

    /// 入力フォーム内容が有効か
    @MainActor
    @Published private(set) var isInputFormValid = true

    /// 入力フォーム内容が有効か評価されて表示されるメッセージ
    @MainActor
    var inputFormvalidatedMessage: String {
        isInputFormValid ? "数字が新しければ新しいルームが作られます" : "6文字以下の名前と4桁の数字が必要です"
    }

    /// カード一覧画面に遷移するか
    @MainActor
    @Published var willPushCardListView = false

    // MARK: - ViewModel

    @MainActor
    @Published var isButtonEnabled = true

    @MainActor
    @Published var isShownLoader = false

    @MainActor
    @Published var isShownBanner = false

    @MainActor
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    // MARK: - Private

    /// 監視対象一覧
    private var cancellables = Set<AnyCancellable>()

    /// 入力フォーム内容を監視する
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

    /// 入力フォーム/名前が有効か
    private func isInputNameValid(_ name: String) -> Bool {
        !name.isEmpty && name.count <= 6
    }

    /// 入力フォーム/ルームIDが有効か
    private func isInputRoomIdValid(_ roomId: String) -> Bool {
        if let inputInt = Int(roomId) {
            return String(inputInt).count == 4
        } else {
            return false
        }
    }

    /// 入力フォーム内容の監視を破棄する
    private func disposeInputForm() {
        cancellables.forEach { subscription in
            subscription.cancel()
        }
    }
}
