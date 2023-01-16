import Foundation

protocol CardListObservable: ObservableObject, ViewModel {
    /// ルーム
    @MainActor var room: Room { get set }

    /// ヘッダーテキスト
    @MainActor var headerTitle: String { get set }

    /// ユーザーのカード選択状況一覧
    @MainActor var userSelectStatusList: [UserSelectStatus] { get set }

    /// 選択済みカード一覧が公開されるか
    @MainActor var isShownSelectedCardList: Bool { get set }

    /// 設定画面に遷移するか
    @MainActor var willPushSettingView: Bool { get set }
}

protocol CardListPresentation: Presentation {
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
    /// ルームIDを必要とするルームリポジトリを有効にする
    /// - parameter roomId: ルームID
    func setupRoomRepository(roomId: Int)

    /// ルームが存在するか確認する
    /// - parameter roomId: ルームID:
    /// - returns ルームが存在するか
    func checkRoomExist(roomId: Int) async -> Bool

    /// ユーザーを購読する
    func subscribeUsers()

    /// ユーザーの購読を解除する
    func unsubscribeUsers()

    /// カードパッケージを購読する
    func subscribeCardPackages()

    /// カードバッケージの購読を解除する
    func unsubscribeCardPackages()

    /// 選択されたカードIDを更新する
    /// - parameter selectedCardDictionary: カレントユーザーIDと選択されたカードIDの辞書
    func updateSelectedCardId(selectedCardDictionary: [String: String])

    /// ユーザーを要求する
    /// - parameter userId:　ユーザーID
    func requestUser(userId: String)

    /// ルームを要求する
    func requestRoom() async
}

protocol CardListInteractorOutput: AnyObject {
    /// ユーザーを出力する
    func outputUser(_ user: User)

    /// ルームを出力する
    @MainActor func outputRoom(_ room: Room)

    /// ヘッダーテキストを表示する
    @MainActor func showHeaderTitle()

    /// ユーザーの選択状況一覧を更新する
    @MainActor func updateUserSelectStatusList()

    /// データ処理の成功を出力
    @MainActor func outputSuccess(message: String)

    /// エラーを出力
    @MainActor func outputError(_ error: Error, message: String)
}
