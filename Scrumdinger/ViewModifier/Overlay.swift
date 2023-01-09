import SwiftUI

struct Overlay<T: View>: ViewModifier {
    /// 表示するか
    @Binding var isShown: Bool
    
    /// バナー、トースト等上に重ねるView
    let overlayView: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShown {
                overlayView
            }
        }
    }
}
