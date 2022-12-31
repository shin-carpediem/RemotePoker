import Neumorphic
import SwiftUI

struct SelectThemeColorView: View {
    @Environment(\.presentationMode) var presentation
    
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: SelectThemeColorPresenter
    }
    
    /// View生成時
    init(dependency: Dependency, viewModel: SelectThemeColorViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        
        construct()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: SelectThemeColorViewModel
    
    private func construct() {
        dependency.presenter.outputColorList()
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()
            VStack(alignment: .leading) {
                colorList
            }
        }
        .navigationTitle("ThemeColor")
    }
    
    /// カラー一覧
    private var colorList: some View {
        List(viewModel.themeColorList, id: \.self) { color in
            colorCell(color)
        }
        .listStyle(.insetGrouped)
    }
    
    /// カラーセル
    private func colorCell(_ color: ThemeColor) -> some View {
        Button {
            dependency.presenter.didTapColor(themeColor: color)
        } label: {
            Text(color.rawValue)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Preview

struct SelectThemeColorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectThemeColorView(dependency: .init(
            presenter: .init(
                dependency: .init(
                    dataStore: .init(),
                    viewModel: .init()))),
                             viewModel: .init())
        .previewDisplayName("テーマカラー選択画面")
    }
}
