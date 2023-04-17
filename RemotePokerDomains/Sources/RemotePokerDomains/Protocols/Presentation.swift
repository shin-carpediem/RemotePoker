public protocol Presentation {
    /// View開始時
    func viewDidLoad()

    /// View再開時 (viewWillAppear or viewDidAppear に対応)
    func viewDidResume()

    /// View中断時 (viewWillDisappear or viewDisappear に対応)
    func viewDidSuspend()
}
