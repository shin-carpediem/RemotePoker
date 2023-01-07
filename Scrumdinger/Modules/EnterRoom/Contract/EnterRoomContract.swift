protocol EnterRoomPresentation: Presentation {
    /// カレントユーザー
    var currentUser: User { get }
    
    /// カレントルーム
    var currentRoom: Room? { get }
    
    /// どのルームに入るか
    var enterRoomAction: EnterRoomAction { get }
    
    /// 入力フォームが有効か
    /// - returns: 有効か
    func isInputFormValid() -> Bool
    
    /// 入力内容が無効だと示すアラートを表示する
    func showInputInvalidAlert()
    
    /// 入室中のルームに入るボタンが押された
    func didTapEnterCurrentRoomButton()
    
    /// 入室中のルームに入るキャンセルが押された
    func didCancelEnterCurrentRoomButton()
    
    /// ルームに入るボタンが押された
    /// - parameter userName: ユーザー名
    /// - parameter roomId: ルームID:
    func didTapEnterRoomButton(userName: String, roomId: Int)
}

protocol EnterRoomUseCase: AnyObject {
    /// ルームリポジトリを扱えるようにする
    /// - parameter roomId: ルームID
    func setupRoomRepository(roomId: Int)
    
    /// 存在するカレントルームが ユーザーにあるか確認する
    /// - parameter roomId: ルームID:
    func checkUserInCurrentRoom(roomId: Int) async
    
    /// ユーザーを要求する
    /// - parameter userId:　ユーザーID
    func requestUser(userId: String)
    
    /// ルームを要求する
    /// - parameter roomId: ルームID
    func requestRoom(roomId: Int) async
    
    /// ルームにユーザーを追加する
    /// - parameter user: ユーザー
    func adduserToRoom(user: User) async
    
    /// ルームを新規作成する
    /// - parameter room: ルーム
    func createRoom(room: Room) async
}

protocol EnterRoomInteractorOutput: AnyObject {
    /// ユーザーを出力する
    func outputUser(_ user: User)
    
    /// ルームを出力する
    func outputRoom(_ room: Room)
    
    /// 存在するカレントルームが ユーザーにあるかを出力する
    func outputIsUserInCurrentRoom(_ isIn: Bool)
    
    /// 入室中のルームに入るか促すアラートを出力する
    func outputEnterCurrentRoomAlert()
    
    /// データ処理の成功を出力
    func outputSuccess(message: String)
    
    /// エラーを出力
    func outputError(_ error: Error, message: String)
}
