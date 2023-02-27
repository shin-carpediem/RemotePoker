protocol DependencyInjectable {
    /// 依存性
    associatedtype Dependency

    /// 依存性を注入する
    /// - parameter dependency: 依存性
    func inject(_ dependency: Dependency)
}
