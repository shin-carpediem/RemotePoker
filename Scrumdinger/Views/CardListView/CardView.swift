import SwiftUI

struct CardView: View {
    /// ID
    let id: Int

    /// 色
    let color: Color

    /// 見積もりポイント
    let point: CardListModel.Card

    /// 見積もりポイント一覧
    let pointList: CardListModel
    
    var body: some View {
        Button(action: {
            isPresentedModal = true
        }) {
            Text("\(point.point)")
                .frame(width: 160, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(point.outputForegroundColor(id))
                .background(point.outputCardColor(id, color))
                .border(LinearGradient(gradient: Gradient(colors: [.white, color]), startPoint: .topLeading,endPoint: .bottomTrailing), width: 2)
                // cornerRadiusはframeやforegroundColor/backgroundの後に指定しないと適用されない
                .cornerRadius(10)
        }
        .sheet(isPresented: $isPresentedModal) {
            NavigationView {
                CardModalView(id: id,
                              color: color,
                              point: point,
                              pointList: pointList)
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
                     point: cardNumber0,
                     pointList: estimateNumberSet)
            CardView(id: 1,
                     color: .green,
                     point: cardNumber1,
                     pointList: estimateNumberSet)
            CardView(id: 2,
                     color: .green,
                     point: cardNumber2,
                     pointList: estimateNumberSet)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
