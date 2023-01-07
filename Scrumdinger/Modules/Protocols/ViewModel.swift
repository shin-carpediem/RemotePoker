protocol ViewModel {
    /// ボタンが有効か
    var isButtonEnabled: Bool { get set }
    
    /// インジケータを表示するか
    var isShownIndicator: Bool { get set }
    
    /// 通知バナーを表示するか
    var isShownBanner: Bool { get set }
    
    /// 通知バナーのメッセージ
    var bannerMessgage: NotificationMessage { get set }
}
