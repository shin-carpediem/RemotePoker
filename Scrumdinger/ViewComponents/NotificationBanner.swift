import SwiftUI

struct NotificationMessage {
    /// 種類
    var type: MessageType

    /// テキスト
    var text: String
    
    enum MessageType {
        /// 成功時
        case onSuccess

        /// 失敗時
        case onFailure
    }
}

struct NotificationMessageViewModel {
    /// 背景
    var backGroundColor: Color

    /// アイコン名
    var iconName: String
}

struct NotificationBanner: View {
    /// バナーを表示するか
    @Binding var isShown: Bool

    let message: NotificationMessage?

    // MARK: - Private

    private var viewModel: NotificationMessageViewModel? {
        guard let message = message else { return nil }
        switch message.type {
        case .onSuccess:
            return NotificationMessageViewModel(backGroundColor: .gray, iconName: "checkmark.circle")

        case .onFailure:
            return NotificationMessageViewModel(backGroundColor: .red, iconName: "exclamationmark.square")
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

    var body: some View {
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
