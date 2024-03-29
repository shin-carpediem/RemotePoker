import Foundation
import Model
import Protocols

public protocol CardListPresentation: AnyObject, Presentation {
    /// カードを選択した
    /// - parameter cardId: カードID
    func didSelectCard(cardId: Int)

    /// 選択済みカード一覧を公開するボタンがタップされた
    func didTapOpenSelectedCardListButton()

    /// カード選択画面に戻るボタンがタップされた
    func didTapBackButton()

    /// 設定ボタンがタップされた
    func didTapSettingButton()
}

public protocol CardListUseCase: AnyObject {
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID:
    /// - returns: ルームが存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// カレントルームを購読する
    func subscribeCurrentRoom()

    /// 選択されたカードIDを更新する
    /// - parameter selectedCardDictionary: カレントユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: Int])

    /// ユーザーを要求する
    func requestUser() async
}

public protocol CardListInteractorOutput: AnyObject {
    /// カレントユーザーを出力する
    func outputCurrentUser(_ user: UserModel)

    /// カレントルームを出力する
    func outputRoom(_ currentRoom: CurrentRoomModel)

    /// データ処理の成功を出力する
    func outputSuccess(message: String)

    /// エラーを出力する
    func outputError(_ error: Error, message: String)
}
