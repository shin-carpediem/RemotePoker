import SwiftUI

struct OpenCardView: View {
    /// ユーザーのカード選択状況
    var userSelectStatus: UserSelectStatus
    
    // MARK: - View
    
    var body: some View {
        VStack {
            userName
            
            if userSelectStatus.selectedCard != nil {
                selectedCardView
            } else {
                userNotSelectedView
            }
        }
    }
    
    private var userName: some View {
        Text(userSelectStatus.user.name)
    }
    
    private var selectedCardView: some View {
        Text(userSelectStatus.selectedCard!.point)
            .frame(width: 170, height: 120)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(userSelectStatus.selectedCard!.fontColor)
            .background(userSelectStatus.selectedCard!.outputBackgroundColor(color: userSelectStatus.themeColor))
            .cornerRadius(10)
    }
    
    private var userNotSelectedView: some View {
        Text("Not Selected Yet")
            .frame(width: 170, height: 120)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .background(.gray)
            .cornerRadius(10)
    }
}

// MARK: - Preview

// TODO: なぜか落ちる
struct OpenCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpenCardView(userSelectStatus: .init(
                id: 0,
                user: CardListView_Previews.me,
                themeColor: .buttercup,
                selectedCard: CardView_Previews.card2))
            .previewDisplayName("選択されたカード")
            
            OpenCardView(userSelectStatus: .init(
                id: 0,
                user: CardListView_Previews.me,
                themeColor: .buttercup,
                selectedCard: nil))
            .previewDisplayName("カード未選択")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
