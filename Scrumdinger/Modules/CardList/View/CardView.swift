import SwiftUI

struct CardView: View {
    /// カード
    var card: Card
    
    /// テーマカラー
    var themeColor: ThemeColor
    
    var body: some View {
        Button(action: {
            isShownPointCheckAlert = true
        }) {
            Text("\(card.point)")
                .frame(width: 160, height: 120)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(card.fontColor)
                .background(card.outputBackgroundColor(color: themeColor))
                .border(LinearGradient(gradient: Gradient(colors: [.white, Color(themeColor.rawValue)]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing),
                        width: 2)
                .cornerRadius(10)
        }
        .alert("Confirm",
               isPresented: $isShownPointCheckAlert,
               actions: {
            Button("Cancel") {}
            Button("OK") {
                // TODO: ポイント登録の処理
            }
        }, message: {
            Text("You are about to submit card: \(card.point)")
        })
    }
    
    // MARK: - Private

    /// 見積もりポイントの確認アラートを表示するか
    @State private var isShownPointCheckAlert = false
}

// MARK: - Preview

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(card: CardPackage.sampleCardList[0],
                     themeColor: .bubblegum)
            .previewDisplayName("色/薄い")
            
//            CardView(card: CardPackage.sampleCardList[4],
//                     themeColor: .green)
//            .previewDisplayName("色/中間")
//
//            CardView(card: CardPackage.sampleCardList[9],
//                     themeColor: .green)
//            .previewDisplayName("色/濃い")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
