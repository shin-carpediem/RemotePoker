import Neumorphic
import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentation
   
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: SettingPresenter
    }
    
    init(dependency: Dependency, viewModel: SettingViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: SettingViewModel
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main.ignoresSafeArea()
            VStack(alignment: .leading) {
                leaveButton
                    .padding()
                Divider()
                Spacer()
            }
        }
    }
    
    /// 退出ボタン
    private var leaveButton: some View {
        Button(action: {
            dependency.presenter.didTapLeaveRoomButton()
            presentation.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .foregroundColor(.gray)
                Text("Leave Room")
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Preview

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(dependency: .init(
            presenter: .init(
                dependency: .init(
                    dataStore: .init(),
                    currentUser: CardListView_Previews.me,
                    viewModel: .init()))),
                    viewModel: .init())
        .previewDisplayName("設定画面")
    }
}
