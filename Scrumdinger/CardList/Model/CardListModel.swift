import SwiftUI

struct CardListModel: Identifiable {
    /// ID
    var id: String = UUID().uuidString
    
    /// 色
    var color: Color
    
    /// カード一覧
    var cardList: [Card] = []
    
    /// カード
    struct Card: Identifiable, Equatable {
        /// ID
        var id: String = UUID().uuidString
        
        /// 見積もりポイント
        var point: String
                
        func outputForegroundColor(_ cardIndex: Int) -> Color {
            outputOpacity(cardIndex) >= 0.5 ? .white : .gray
        }
        
        func outputCardColor(_ cardIndex: Int, _ color: Color) -> Color {
            let newOpacity = outputOpacity(cardIndex)
            return color.opacity(newOpacity)
        }
        
        // MARK: - Private
        
        private func outputOpacity(_ cardIndex: Int) -> Double {
            let number: Int = cardIndex >= 10 ? 9 : cardIndex
            return Double("0.\(number)") ?? 1.0
        }
    }
}

extension CardListModel {
    static let sampleData = CardListModel(color: .purple,
                                          cardList: numberSetSampleData)
    
    static let numberSetSampleData = [Card(point: "0"),
                                      Card(point: "0.5"),
                                      Card(point: "1"),
                                      Card(point: "2"),
                                      Card(point: "3"),
                                      Card(point: "5"),
                                      Card(point: "8"),
                                      Card(point: "13"),
                                      Card(point: "20"),
                                      Card(point: "40")]
}
