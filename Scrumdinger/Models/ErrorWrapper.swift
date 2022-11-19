import Foundation

struct ErrorWrapper: Identifiable {
    /// ID
    let id: UUID = UUID()
    
    /// エラー
    let error: Error
    
    /// ガイダンス
    let guidance: String
}
