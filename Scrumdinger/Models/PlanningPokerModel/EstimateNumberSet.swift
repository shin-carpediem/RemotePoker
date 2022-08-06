import SwiftUI

struct EstimateNumberSet: Identifiable {
    let id: UUID
    let color: Color
    var numberSet: [EstimateNumber] = []
    
    init(id: UUID = UUID(), color: Color, numberSet: [EstimateNumber]) {
        self.id = id
        self.color = color
        self.numberSet = numberSet
    }
    
    struct EstimateNumber: Identifiable, Equatable {
        let id: UUID
        var number: String
        
        init(id: UUID = UUID(), number: String) {
            self.id = id
            self.number = number
        }
    }
}

extension EstimateNumberSet {
    static let sampleData: EstimateNumberSet = EstimateNumberSet(
        color: Color(red: 0, green: 200, blue: 11),
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
