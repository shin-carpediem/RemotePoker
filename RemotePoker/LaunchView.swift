import RemotePokerViews
import SwiftUI

struct LaunchView: View {
    // MARK: View
    
    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()
            ProgressView()
        }
    }
}

// MARK: - Preview

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
