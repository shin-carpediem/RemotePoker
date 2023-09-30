import Neumorphic
import SwiftUI

struct InputText: View {
    var text: Binding<String>
    var placeholder: String

    // MARK: - View

    var body: some View {
        TextField(placeholder, text: text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.Neumorphic.main)
                    .softInnerShadow(
                        RoundedRectangle(cornerRadius: 20),
                        darkShadow: Color.Neumorphic.darkShadow,
                        lightShadow: Color.Neumorphic.lightShadow,
                        spread: 0.2,
                        radius: 2)
            )
            .tint(.gray)
            .foregroundColor(.gray)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Text("入力なし")
        InputText(text: .constant(""), placeholder: "Name")
        
        Text("入力あり")
        InputText(text: .constant("This is input Name"), placeholder: "Name")
    }
}
