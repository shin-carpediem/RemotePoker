import SwiftUI

public struct Overlay<T: View>: ViewModifier {
    @Binding public var isShown: Bool

    /// バナー、トースト等、上に重ねるView
    public let overlayView: T

    public init(isShown: Binding<Bool>, overlayView: T) {
        _isShown = isShown
        self.overlayView = overlayView
    }

    // MARK: - ViewModifier

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isShown {
                overlayView
            }
        }
    }
}
