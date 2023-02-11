import Foundation

protocol CardListObservable: ObservableObject, ViewModel {
    /// ルーム
    @MainActor
    var room: Room { get set }

    /// ヘッダーテキスト
    @MainActor
    var headerTitle: String { get set }

    /// ユーザーのカード選択状況一覧
    @MainActor
    var userSelectStatusList: [UserSelectStatus] { get set }

    /// 選択済みカード一覧が公開されるか
    @MainActor
    var isShownSelectedCardList: Bool { get set }

    /// ボタンの説明テキスト
    @MainActor
    var buttonText: String { get }

    @MainActor
    /// フローティングアクションボタンのシンボル名
    var fabIconName: String { get }

    /// 設定画面に遷移するか
    @MainActor
    var willPushSettingView: Bool { get set }
}

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
    func requestUser(userId: String)
}

protocol CardListInteractorOutput: AnyObject {
    /// カレントユーザーを出力する
    @MainActor
    func outputCurrentUser(_ user: User)
    
    /// ユーザーリストを出力する
    @MainActor
    func outputUserList(_ userList: [User])

    /// カードパッケージを出力する
    @MainActor
    func outputCardPackage(_ cardPackage: CardPackage)

    /// データ処理の成功を出力
    @MainActor
    func outputSuccess(message: String)

    /// エラーを出力
    @MainActor
    func outputError(_ error: Error, message: String)
}
