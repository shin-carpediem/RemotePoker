import Neumorphic
import SwiftUI

struct SettingView: View, ModuleAssembler {
    @Environment(\.presentationMode) var presentation
   
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: SettingPresenter
        var room: Room
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
                selecteThemeColorButton
                    .padding()
                Divider()
                Spacer()
                leaveButton
                    .padding()
                Divider()
                Spacer()
            }
        }
    }
    
    /// テーマカラー選択ボタン
    private var selecteThemeColorButton: some View {
        Button(action: {
            dependency.presenter.didTapSelectThemeColorButton()
        }) {
            HStack {
                Image(systemName: "heart")
                    .foregroundColor(.gray)
                Text("Select Theme Color")
                    .foregroundColor(.gray)
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
                    viewModel: .init())),
            room: CardListView_Previews.room1),
                    viewModel: .init())
        .previewDisplayName("設定画面")
    }
}
