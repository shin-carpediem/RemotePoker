import RemotePokerViews
import SwiftUI

struct LaunchView: View {
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()
            ProgressView()
        }
    }
}

// MARK: - Preview

#Preview {
    LaunchView()
}
