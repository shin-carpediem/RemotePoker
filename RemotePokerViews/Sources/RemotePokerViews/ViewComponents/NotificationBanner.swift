import SwiftUI

public struct NotificationMessage {
    /// 種類
    public enum MessageType {
        /// 成功時
        case onSuccess

        /// 失敗時
        case onFailure
    }

    /// 種類
    public var type: MessageType

    /// テキスト
    public var text: String

    public init(type: MessageType, text: String) {
        self.type = type
        self.text = text
    }
}

public struct NotificationMessageViewModel {
    /// 背景
    public var backGroundColor: Color

    /// アイコン名
    public var iconName: String

    public init(backGroundColor: Color, iconName: String) {
        self.backGroundColor = backGroundColor
        self.iconName = iconName
    }
}

public struct NotificationBanner: View {
    /// バナーを表示するか
    @Binding public var isShown: Bool

    public let message: NotificationMessage?

    public init(isShown: Binding<Bool>, message: NotificationMessage?) {
        self._isShown = isShown
        self.message = message
    }

    // MARK: - Private

    private var viewModel: NotificationMessageViewModel? {
        guard let message = message else { return nil }
        switch message.type {
        case .onSuccess:
            return NotificationMessageViewModel(
                backGroundColor: .gray, iconName: "checkmark.circle")

        case .onFailure:
            return NotificationMessageViewModel(
                backGroundColor: .red, iconName: "exclamationmark.square")
        }
    }

    /// バナーを非表示にする
    @MainActor
    private func hideBanner() {
        isShown = false
    }

    /// View表示時
    private func construct() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await hideBanner()
        }
    }

    // MARK: - View

    public var body: some View {
        if let message = message {
            banner(message)
                .padding()
                .animation(.easeOut, value: isShown)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onTapGesture { withAnimation { hideBanner() } }
                .onAppear { construct() }
        }
    }

    /// バナーView
    private func banner(_ message: NotificationMessage) -> some View {
        return VStack {
            HStack {
                Image(systemName: viewModel?.iconName ?? "")
                Text(message.text)
                Spacer()
            }
            .foregroundColor(.white)
            .padding(12)
            .background(viewModel?.backGroundColor)
            .cornerRadius(8)
            Spacer()
        }
    }
}

// MARK: - Preview

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBanner(
            isShown: .constant(true),
            message: .init(type: .onSuccess, text: "成功したよ")
        )
        .previewDisplayName("通知バナー/成功時")

        NotificationBanner(
            isShown: .constant(true),
            message: .init(type: .onFailure, text: "失敗したよ")
        )
        .previewDisplayName("通知バナー/失敗時")
    }
}
