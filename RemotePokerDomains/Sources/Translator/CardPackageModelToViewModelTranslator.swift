import Model
import Protocols
import SwiftUI
import ViewModel

public struct CardPackageModelToViewModelTranslator: Translator {
    public init() {}

    // MARK: - Translator

    public typealias Input = CardPackageModel
    public typealias Output = CardPackageViewModel

    public func translate(_ input: Input) -> Output {
        let themeColor = CardPackageThemeColor(rawValue: input.themeColor) ?? .oxblood
        let cardList: [CardPackageViewModel.Card] = input.cardList.map {
            CardPackageViewModel.Card(
                id: $0.id,
                estimatePoint: $0.estimatePoint,
                index: $0.index,
                fontColor: applyFontColor(toIndex: $0.index),
                backgroundColor: applyBackgroundColor(
                    toIndex: $0.index,
                    with: themeColor))
        }
        return CardPackageViewModel(
            id: input.id,
            themeColor: themeColor,
            cardList: cardList)
    }

    // MARK: - Private

    /// 文字色を指定する
    private func applyFontColor(toIndex index: Int) -> Color {
        let number: Int = (index >= 10 ? 9 : index)
        let opacity: Double = Double("0.\(number)") ?? 1.0
        return opacity >= 0.4 ? .white : .gray
    }

    /// 指定カードの背景色を指定する
    private func applyBackgroundColor(toIndex index: Int, with color: CardPackageThemeColor)
        -> Color
    {
        let number: Int = (index >= 10 ? 9 : index)
        let opacity: Double = Double("0.\(number)5") ?? 1.0
        return Color(color.rawValue).opacity(opacity)
    }
}
