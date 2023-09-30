import SwiftUI
import ViewModel

public struct NotificationBanner: View {
    @Binding public var isShown: Bool
    public let viewModel: NotificationBannerViewModel

    public init(isShown: Binding<Bool>, viewModel: NotificationBannerViewModel) {
        self._isShown = isShown
        self.viewModel = viewModel
    }

    // MARK: - Private

    @MainActor private func hideBanner() {
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
        VStack {
            banner
                .padding()
                .animation(.easeOut, value: isShown)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onTapGesture { withAnimation { hideBanner() } }
                .onAppear { construct() }
            Spacer()
        }
    }

    private var banner: some View {
        HStack {
            Image(systemName: viewModel.iconName)
            Text(viewModel.text)
            Spacer()
        }
        .foregroundColor(.white)
        .padding(12)
        .background(viewModel.backGroundColor)
        .cornerRadius(8)
    }
}

// MARK: - Preview

#Preview("通知バナー/成功時") {
    NotificationBanner(
        isShown: .constant(true),
        viewModel: .init(type: .onSuccess, text: "成功したよ")
    )
}

#Preview("通知バナー/失敗時") {
    NotificationBanner(
        isShown: .constant(true),
        viewModel: .init(type: .onFailure, text: "失敗したよ")
    )
}
