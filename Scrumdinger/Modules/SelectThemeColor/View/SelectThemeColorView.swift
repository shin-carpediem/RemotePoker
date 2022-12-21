import Neumorphic
import SwiftUI

struct SelectThemeColorView: View {
    @Environment(\.presentationMode) var presentation
    
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: SelectThemeColorPresenter
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    // MARK: - View
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

struct SelectThemeColorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectThemeColorView(dependency: .init(
            presenter: .init(
                dependency: .init(
                    dataStore: .init()))))
    }
}
