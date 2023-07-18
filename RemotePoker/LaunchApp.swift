import RemotePokerViews
import SwiftUI

final class LaunchAppViewModel: ObservableObject {
    enum LaunchScreen {
        /// アプリ起動直後の画面
        case launchView
        /// ルームに入るためのフォーム入力画面
        case enterRoomView
        /// カード一覧画面
        case cardListView
    }
    
    @Published var launchScreen: LaunchScreen = .launchView
}

struct LaunchApp: View, ModuleAssembler {
    init(viewModel: LaunchAppViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Private
    
    @ObservedObject private var viewModel: LaunchAppViewModel
    
    // MARK: View
    
    var body: some View {
        switch viewModel.launchScreen {
        case .launchView:
            LaunchView()
            
        case .enterRoomView:
            assmebleEnterRoomModule()

        case .cardListView:
            assembleCardListModule()
        }
    }
}

// MARK: Preview

struct LaunchApp_Previews: PreviewProvider {
    static var previews: some View {
        LaunchApp(viewModel: .init())
    }
}
