import SwiftUI

struct SelectThemeColorView: View {
    @Environment(\.presentationMode) var presentation
    
    // MARK: - Dependency
    
    struct Dependency {
        var presenter: SelectThemeColorPresentation
    }
    
    init(dependency: Dependency, viewModel: SelectThemeColorViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private var dependency: Dependency
    
    @ObservedObject private var viewModel: SelectThemeColorViewModel
    
    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, message: viewModel.bannerMessgage)
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.screenBackground
            contentView
            if viewModel.isShownLoader { Loader() }
        }
        .navigationTitle("ThemeColor")
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }
    
    /// コンテンツビュー
    private var contentView: some View {
        VStack(alignment: .leading) {
            colorList
        }
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
        let isThemeColor = color == viewModel.selectedThemeColor
        // TODO: 背景色がつかない
        let themeLabel: some View = {
            Text(color.rawValue)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.gray)
                .background(color.opacity(0.5))
        }()
        let label: some View = {
            Text(color.rawValue)
                .foregroundColor(.gray)
        }()
        
        return Button {
            dependency.presenter.didTapColor(color: color)
        } label: {
            if isThemeColor {
                themeLabel
            } else {
                label
            }
        }
        .disabled(!viewModel.isButtonEnabled)
    }
}

// MARK: - Preview

struct SelectThemeColorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectThemeColorView(dependency: .init(presenter: SelectThemeColorPresenter()),
                             viewModel: .init())
        .previewDisplayName("テーマカラー選択画面")
    }
}
