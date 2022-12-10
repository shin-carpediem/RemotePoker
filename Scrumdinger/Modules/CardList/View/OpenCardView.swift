import SwiftUI

struct OpenCardView: View {
    /// ユーザーのカード選択状況
    var userSelectStatus: UserSelectStatus
    
    // MARK: - View
    
    var body: some View {
        VStack {
            Text(userSelectStatus.user.name)
            
            Text(userSelectStatus.selectedCard?.point ?? "")
                .frame(width: 170, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(userSelectStatus.selectedCard?.fontColor)
                .background(userSelectStatus.selectedCard?.outputBackgroundColor(color: userSelectStatus.themeColor))
                .cornerRadius(10)
        }
    }
}

// MARK: - Preview

// TODO: なぜか落ちる
struct OpenCardView_Previews: PreviewProvider {
    static var previews: some View {
        OpenCardView(userSelectStatus: .init(
            id: 0,
            user: CardListView_Previews.me,
            themeColor: .buttercup))
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("選択されたカード")
    }
}
