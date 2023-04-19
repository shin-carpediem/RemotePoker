import SwiftUI
import ViewModel

public struct NotificationBanner: View {
    /// バナーを表示するか
    @Binding public var isShown: Bool

    public let viewModel: NotificationBannerViewModel

    public init(isShown: Binding<Bool>, viewModel: NotificationBannerViewModel) {
        self._isShown = isShown
        self.viewModel = viewModel
    }

    // MARK: - Private

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
        banner
            .padding()
            .animation(.easeOut, value: isShown)
            .transition(.move(edge: .top).combined(with: .opacity))
            .onTapGesture { withAnimation { hideBanner() } }
            .onAppear { construct() }
    }

    /// バナーView
    private var banner: some View {
        VStack {
            HStack {
                Image(systemName: viewModel.iconName)
                Text(viewModel.text)
                Spacer()
            }
            .foregroundColor(.white)
            .padding(12)
            .background(viewModel.backGroundColor)
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
            viewModel: .init(type: .onSuccess, text: "成功したよ")
        )
        .previewDisplayName("通知バナー/成功時")

        NotificationBanner(
            isShown: .constant(true),
            viewModel: .init(type: .onFailure, text: "失敗したよ")
        )
        .previewDisplayName("通知バナー/失敗時")
    }
}
