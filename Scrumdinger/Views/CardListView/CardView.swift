import SwiftUI

struct CardView: View {
    /// ID
    let id: Int

    /// 色
    let color: Color

    /// カード
    let card: CardListModel.Card

    /// カード一覧
    let cardList: CardListModel
    
    var body: some View {
        Button(action: {
            isPresentedModal = true
        }) {
            Text("\(card.point)")
                .frame(width: 160, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(card.outputForegroundColor(id))
                .background(card.outputCardColor(id, color))
                .border(LinearGradient(gradient: Gradient(colors: [.white, color]), startPoint: .topLeading,endPoint: .bottomTrailing), width: 2)
                // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
                .cornerRadius(10)
        }
        .sheet(isPresented: $isPresentedModal) {
            NavigationView {
                CardModalView(id: id,
                              color: color,
                              card: card,
                              cardList: cardList)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {
                                isPresentedModal = false
                            }) {
                                Text("X")
                                    .font(.system(size: 32))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Private
    
    /// モーダルが既に表示されているか
    @State private var isPresentedModal = false
}

// MARK: - Preview

struct CardView_Previews: PreviewProvider {
    static var estimateNumberSet = CardListModel.sampleData
    static var cardNumber0 = CardListModel.numberSetSampleData[0]
    static var cardNumber1 = CardListModel.numberSetSampleData[1]
    static var cardNumber2 = CardListModel.numberSetSampleData[2]
    
    static var previews: some View {
        Group {
            CardView(id: 0,
                     color: .green,
                     card: cardNumber0,
                     cardList: estimateNumberSet)
            CardView(id: 1,
                     color: .green,
                     card: cardNumber1,
                     cardList: estimateNumberSet)
            CardView(id: 2,
                     color: .green,
                     card: cardNumber2,
                     cardList: estimateNumberSet)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
