import Neumorphic
import SwiftUI

struct SelectThemeColorView: View {
    @Environment(\.presentationMode) var presentation
    
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: SelectThemeColorPresenter
    }
    
    init(dependency: Dependency, viewModel: SelectThemeColorViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        
        construct()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: SelectThemeColorViewModel
    
    /// View生成時
    private func construct() {
        dependency.presenter.outputColorList()
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()
            VStack(alignment: .leading) {
                ScrollView { colorList }
            }
        }
    }
    
    /// カラー一覧
    private var colorList: some View {
        List {
            Section {
                ForEach(0 ..< viewModel.themeColorList.count) { index in
                    let color = viewModel.themeColorList[index]
                    Button {
                        dependency.presenter.didTapColor(color: color)
                    } label: {
                        Text(color.rawValue)
                    }
                }
            } header: {
                Text("Theme Color")
            }
        }
        .listStyle(.insetGrouped)
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
    }
}
