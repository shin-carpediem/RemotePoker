import Neumorphic
import SwiftUI

struct FormStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(RoundedRectangle(cornerRadius: 20)
                .fill(Color.Neumorphic.main)
                .softInnerShadow(RoundedRectangle(cornerRadius: 20),
                                 darkShadow: Color.Neumorphic.darkShadow,
                                 lightShadow: Color.Neumorphic.lightShadow,
                                 spread: 0.2,
                                 radius: 2))
            .tint(.gray)
            .foregroundColor(.gray)
    }
}
