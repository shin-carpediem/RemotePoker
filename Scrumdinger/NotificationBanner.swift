import SwiftUI

enum NotificationMessageType {
    /// 成功時
    case onSuccess
    
    /// 失敗時
    case onFailure
}

struct NotificationMessage {
    /// 種類
    var type: NotificationMessageType
    
    /// テキスト
    var text: String
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
        guard let message else { return nil }
        switch message.type {
        case .onSuccess:
            return .init(backGroundColor: .gray, iconName: "checkmark.circle")
            
        case .onFailure:
            return .init(backGroundColor: .red, iconName: "exclamationmark.square")
        }
    }
    
    private func hideBanner() {
        isShown = false
    }
    
    private func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                hideBanner()
            }
        }
    }
    
    // MARK: - View
    
    var body: some View {
        if let message {
            banner(message)
                .padding()
                .animation(.easeOut)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onTapGesture { withAnimation { hideBanner() } }
                .onAppear { onAppear() }
        }
    }
    
    /// バナーView
    private func banner(_ message: NotificationMessage) -> some View {
        return VStack {
            HStack {
                Image(systemName: viewModel?.iconName ?? "")
                Text(message.text).bold()
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
        NotificationBanner(isShown: .constant(true),
                           message: .init(type: .onSuccess, text: "成功したよ"))
        .previewDisplayName("通知バナー/成功時")
        
        NotificationBanner(isShown: .constant(true),
                           message: .init(type: .onFailure, text: "失敗したよ"))
        .previewDisplayName("通知バナー/失敗時")
    }
}
