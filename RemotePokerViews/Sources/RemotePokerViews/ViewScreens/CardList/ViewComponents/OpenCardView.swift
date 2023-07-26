import CardListDomain
import SwiftUI
import ViewModel

struct OpenCardView: View {
    var userSelectStatus: UserSelectStatusViewModel

    // MARK: Private

    private var selectedCard: CardPackageViewModel.Card? {
        userSelectStatus.selectedCard
    }

    // MARK: View

    var body: some View {
        VStack {
            userName
            if selectedCard == nil {
                userNotSelectedView
            } else {
                selectedCardView
            }
        }
    }

    /// ユーザーネーム
    private var userName: some View {
        Text(userSelectStatus.user.name)
    }

    /// 選択されたカードビュー
    private var selectedCardView: some View {
        Text(selectedCard!.estimatePoint)
            .frame(width: 150, height: 100)
            .font(.largeTitle)
            .foregroundColor(selectedCard!.fontColor)
            .background(selectedCard!.backgroundColor)
            .cornerRadius(10)
    }

    /// カード未選択時のカードビュー
    private var userNotSelectedView: some View {
        Text("Not Selected Yet")
            .frame(width: 150, height: 100)
            .font(.body)
            .foregroundColor(.black)
            .background(.gray)
            .cornerRadius(10)
    }
}

// MARK: Preview

struct OpenCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("選択されたカード")
            OpenCardView(
                userSelectStatus: .init(
                    id: 0,
                    user: CardListView_Previews.me,
                    themeColor: .buttercup,
                    selectedCard: CardView_Previews.card2)
            )

            Text("カード未選択")
            OpenCardView(
                userSelectStatus: .init(
                    id: 0,
                    user: CardListView_Previews.me,
                    themeColor: .buttercup,
                    selectedCard: nil)
            )
        }
        .padding()
    }
}
