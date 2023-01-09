protocol EnterRoomPresentation: Presentation {
    /// カレントユーザー
    var currentUser: User { get }
    
    /// カレントルーム
    var currentRoom: Room { get }
    
    /// 入室中のルームに入るボタンが押された
    func didTapEnterCurrentRoomButton()
    
    /// 入室中のルームに入るキャンセルが押された
    func didCancelEnterCurrentRoomButton()
    
    /// ルームに入るボタンが押された
    /// - parameter inputUserName: 入力されたユーザー名
    /// - parameter inputRoomId: 入力されたルームID
    func didTapEnterRoomButton(inputUserName: String, inputRoomId: String)
}

protocol EnterRoomUseCase: AnyObject {
    /// ルームIDを必要とするルームリポジトリを有効にする
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
    
    /// データ処理の成功を出力
    func outputSuccess(message: String)
    
    /// エラーを出力
    func outputError(_ error: Error, message: String)
}
