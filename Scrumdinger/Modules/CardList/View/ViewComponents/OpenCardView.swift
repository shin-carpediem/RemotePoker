import SwiftUI

struct OpenCardView: View {
    /// ユーザーのカード選択状況
    var userSelectStatus: UserSelectStatus

    // MARK: - Private

    /// 選択されたカード
    private var selectedCard: CardPackageEntity.Card? {
        userSelectStatus.selectedCard
    }

    // MARK: - View

    var body: some View {
        VStack {
            userName
            if selectedCard != nil {
                selectedCardView
            } else {
                userNotSelectedView
            }
        }
    }

    /// ユーザーネーム
    private var userName: some View {
        Text(userSelectStatus.user.name)
    }

    /// 選択されたカードビュー
    private var selectedCardView: some View {
        Text(selectedCard!.point)
            .frame(width: 150, height: 100)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(selectedCard!.fontColor)
            .background(selectedCard!.outputBackgroundColor(color: userSelectStatus.themeColor))
            .cornerRadius(10)
    }

    /// ユーザーが未選択時のビュー
    private var userNotSelectedView: some View {
        Text("Not Selected Yet")
            .frame(width: 150, height: 100)
            .font(.system(size: 16))
            .foregroundColor(.black)
            .background(.gray)
            .cornerRadius(10)
    }
}

// MARK: - Preview

struct OpenCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpenCardView(
                userSelectStatus: .init(
                    id: "0",
                    user: CardListView_Previews.me,
                    themeColor: .buttercup,
                    selectedCard: CardView_Previews.card2)
            )
            .previewDisplayName("選択されたカード")

            OpenCardView(
                userSelectStatus: .init(
                    id: "0",
                    user: CardListView_Previews.me,
                    themeColor: .buttercup,
                    selectedCard: nil)
            )
            .previewDisplayName("カード未選択")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
