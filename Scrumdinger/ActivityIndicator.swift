import SwiftUI

/// [参照元]: https://www.bokukoko.info/entry/2022/06/14/135629
struct ActivityIndicator: View {
    /// インジケータを表示するか
    @State var isAnimating: Bool = false
    
    // MARK: - Private
    
    private func outputScale(index: Int) -> CGFloat {
        return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
    }

    private func outputYOffset(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / 10 - geometry.size.height / 2
    }
    
    private func showIndicator() {
        // 初回ロード時にアイコンが左上に向かっていくアニメーションとなるため、処理を少し待つ。
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isAnimating = true
        }
    }
    
    // MARK: - View
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { indicatorCircle(geometry: geometry, index: $0) }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear { showIndicator() }
    }
    
    /// インジケータの丸
    func indicatorCircle(geometry: GeometryProxy, index: Int) -> some View {
        let width = geometry.size.width / 5
        let height = geometry.size.height / 5
        let angle: Angle = !self.isAnimating ? .degrees(0) : .degrees(360)
        let animation = Animation
            .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
            .repeatForever(autoreverses: false)
        
        return Group {
            Circle()
                .frame(width: width, height: height)
                .scaleEffect(outputScale(index: index))
                .offset(y: outputYOffset(geometry: geometry))
        }.frame(width: geometry.size.width, height: geometry.size.height)
            .rotationEffect(angle)
            // 新iOSではAnimationにUUIDの指定が必要
            .animation(animation, value: UUID())
    }
}

// MARK: - Preview

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
            .frame(width: 200, height: 200)
            .foregroundColor(.gray)
    }
}
