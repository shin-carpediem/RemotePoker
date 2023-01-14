import Neumorphic
import SwiftUI

struct InputText: View {
    /// プレースホルダー
    var placeholder: String

    /// テキスト
    var text: Binding<String>

    // MARK: - View

    var body: some View {
        textField
    }

    private var textField: some View {
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

struct InputText_Previews: PreviewProvider {
    static var previews: some View {
        InputText(placeholder: "Name", text: .constant(""))
            .previewDisplayName("入力フォームテキスト/入力なし")

        InputText(placeholder: "Name", text: .constant("This is input Name"))
            .previewDisplayName("入力フォームテキスト/入力あり")
    }
}
