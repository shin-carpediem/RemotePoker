import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID = UUID()
    let error: Error
    let guidance: String
}
