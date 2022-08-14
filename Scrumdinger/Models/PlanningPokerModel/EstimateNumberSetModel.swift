import SwiftUI

struct EstimateNumberSetModel: Identifiable {
    let id: UUID = UUID()
    let color: Color
    var numberSet: [EstimateNumber] = []
        
    struct EstimateNumber: Identifiable, Equatable {
        let id: UUID = UUID()
        let number: String
        
        // MARK: - Method
                
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

extension EstimateNumberSetModel {
    static let sampleData: EstimateNumberSetModel = EstimateNumberSetModel(
        color: .purple,
        numberSet: numberSetSampleData
    )
    
    static let numberSetSampleData: [EstimateNumber] =
    [
        EstimateNumber(number: "0"),
        EstimateNumber(number: "0.5"),
        EstimateNumber(number: "1"),
        EstimateNumber(number: "2"),
        EstimateNumber(number: "3"),
        EstimateNumber(number: "5"),
        EstimateNumber(number: "8"),
        EstimateNumber(number: "13"),
        EstimateNumber(number: "20"),
        EstimateNumber(number: "40"),
    ]
}
