import Foundation

struct EstimateNumber: Identifiable, Equatable {
    let id: UUID
    var number: String
    
    init(id: UUID = UUID(), number: String) {
        self.id = id
        self.number = number
    }
}

extension EstimateNumber {
    static let sampleData: [EstimateNumber] =
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
