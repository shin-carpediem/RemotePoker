import Foundation

protocol CardListPresentation: AnyObject, Presentation {
    /// カードを選択した
    /// - parameter cardId: カードID
    func didSelectCard(cardId: String)

    /// 選択済みカード一覧を公開するボタンがタップされた
    func didTapOpenSelectedCardListButton()

    /// 選択済みカード一覧をリセットするボタンがタップされた
    func didTapResetSelectedCardListButton()

    /// 設定ボタンがタップされた
    func didTapSettingButton()
}

protocol CardListUseCase: AnyObject {
    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID:
    /// - returns ルームが存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// ユーザーを購読する
    func subscribeUsers()

    /// カードパッケージを購読する
    func subscribeCardPackages()

    /// 選択されたカードIDを更新する
    /// - parameter selectedCardDictionary: カレントユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])

    /// ユーザーを要求する
    /// - parameter userId:　ユーザーID
    func requestUser(userId: String) async
}

protocol CardListInteractorOutput: AnyObject {
    /// カレントユーザーを出力する
    @MainActor
    func outputCurrentUser(_ user: UserModel)

    /// ユーザーリストを出力する
    @MainActor
    func outputUserList(_ userList: [UserModel])

    /// カードパッケージを出力する
    @MainActor
    func outputCardPackage(_ cardPackage: CardPackageModel)

    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
