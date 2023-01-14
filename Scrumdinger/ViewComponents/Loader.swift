import LoaderUI
import SwiftUI

struct Loader: View {
    // MARK: - Private

    private var loader = BallClipRotate()

    // MARK: - View

    var body: some View {
        loader
            .frame(width: 60, height: 60)
            .foregroundColor(.gray)
    }
}

// MARK: - Preview

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
            .previewDisplayName("ローダー")
    }
}
