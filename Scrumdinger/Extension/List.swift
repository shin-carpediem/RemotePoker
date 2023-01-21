import SwiftUI

extension List {
    /// リストそのものの背景色
    func listBackground(_ color: Color) -> some View {
        UITableView.appearance().backgroundColor = UIColor(color)
        return self
    }
}
