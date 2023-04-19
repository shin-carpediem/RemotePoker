import Foundation
import Protocols
import ViewModel

public protocol SelectThemeColorPresentation: AnyObject, Presentation {
    /// カラーをタップした
    /// - parameter color: 選択したカラー
    func didTapColor(color: CardPackageThemeColor)
}
