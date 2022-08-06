import SwiftUI

struct EstimateNumberSet: Identifiable {
    let id: UUID
    let color: Color
    var numberSet: [EstimateNumber]
    
    init(id: UUID = UUID(), color: Color, numberSet: [EstimateNumber]) {
        self.id = id
        self.color = color
        self.numberSet = numberSet
    }
}

extension EstimateNumberSet {
    static let sampleData: EstimateNumberSet = EstimateNumberSet(
        color: Color(red: 0, green: 200, blue: 11),
        numberSet: EstimateNumber.sampleData
    )
}
