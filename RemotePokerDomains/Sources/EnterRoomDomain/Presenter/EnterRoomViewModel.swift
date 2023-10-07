import Combine
import Protocols
import SwiftUI
import ViewModel

public final class EnterRoomViewModel: ObservableObject, ViewModel {
    public init() {
        observeInputForm()
    }

    @Published public var inputName = ""
    @Published public var inputRoomId = ""

    @Published public private(set) var isInputFormValid = true

    @Published public var willPushCardListView = false

    // MARK: - ViewModel

    @Published public var isButtonsEnabled = true
    @Published public var isLoaderShown = false
    @Published public var isBannerShown = false
    @Published public var bannerMessgage = NotificationBannerViewModel(type: .onSuccess, text: "")

    // MARK: - Private

    private var cancellables = Set<AnyCancellable>()

    private func observeInputForm() {
        $inputName
            .combineLatest($inputRoomId)
            .receive(on: DispatchQueue.main)
            .map { [weak self] inputName, inputRoomId -> Bool in
                guard let self else {
                    return false
                }
                return self.isInputNameValid(inputName)
                    && self.isInputRoomIdValid(inputRoomId)
            }
            .assign(to: \.isInputFormValid, on: self)
            .store(in: &cancellables)
    }

    private func isInputNameValid(_ name: String) -> Bool {
        !name.isEmpty && name.count <= 6
    }

    private func isInputRoomIdValid(_ roomId: String) -> Bool {
        guard let inputInt = Int(roomId) else {
            return false
        }
        let validRoomIdLength = 4
        return String(inputInt).count == validRoomIdLength
    }
}
