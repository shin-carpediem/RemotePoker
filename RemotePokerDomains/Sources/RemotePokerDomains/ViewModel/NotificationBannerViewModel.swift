import SwiftUI

public struct NotificationBannerViewModel {
    public enum MessageType {
        case onSuccess
        case onFailure
    }

    public var type: MessageType
    public var text: String

    public var backGroundColor: Color {
        switch type {
        case .onSuccess:
            return .gray

        case .onFailure:
            return .red
        }
    }

    public var iconName: String {
        switch type {
        case .onSuccess:
            return "checkmark.circle"

        case .onFailure:
            return "exclamationmark.square"
        }
    }

    public init(type: MessageType, text: String) {
        self.type = type
        self.text = text
    }
}
