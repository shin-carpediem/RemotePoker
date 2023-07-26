import CardListDomain
import Neumorphic
import RemotePokerData
import Shared
import SwiftUI
import Translator
import ViewModel

public struct CardListView: View {
    @Environment(\.presentationMode) var presentation

    // MARK: - Dependency

    struct Dependency {
        var presenter: CardListPresentation
    }

    init(dependency: Dependency, viewModel: CardListViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }

    // MARK: - Private

    private var dependency: Dependency
    @ObservedObject private var viewModel: CardListViewModel

    private var appConfig: AppConfig {
        guard let appConfig = AppConfigManager.appConfig else {
            fatalError()
        }
        return appConfig
    }
    
    // MARK: - View

    public var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()
            contentView
            navigationForSettingView
            if viewModel.isLoaderShown { ProgressView() }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        // TODO: 不具合が解消されたら、復帰させる。
        // .navigationBarItems(trailing: settingButton)
        .modifier(Overlay(isShown: $viewModel.isBannerShown, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    private var contentView: some View {
        VStack {
            ScrollView {
                if viewModel.isSelectedCardListShown {
                    selectedCardListView
                        .padding()
                } else {
                    cardListView
                        .padding()
                }
            }
            HStack {
                selectedCardPointView
                    .padding(.leading, 32)
                Spacer()
                buttonText
                floatingActionButton
                    .disabled(!viewModel.isButtonsEnabled)
            }
        }
    }
}

// MARK: - View Components

extension CardListView {
    /// 設定ボタン
    private var settingButton: some View {
        Button(action: {
            dependency.presenter.didTapSettingButton()
        }) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.gray)
        }
    }

    /// カード一覧
    private var cardListView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(viewModel.room.cardPackage.cardList) { card in
                let isSelected: Bool =
                    (card.id
                        == viewModel.userSelectStatusList.first(where: {
                        $0.user.id == appConfig.currentUser.id
                        })?.selectedCard?.id)
                CardView(
                    card: card,
                    themeColor: viewModel.room.cardPackage.themeColor,
                    isEnabled: viewModel.isButtonsEnabled,
                    isSelected: isSelected
                ) { selectedCard in
                    dependency.presenter.didSelectCard(cardId: selectedCard.id)
                }
            }
        }
    }

    /// 選択されたカード一覧
    private var selectedCardListView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(viewModel.userSelectStatusList) {
                OpenCardView(userSelectStatus: $0)
            }
        }
    }

    /// 選択されたカードのポイント
    private var selectedCardPointView: some View {
        let currentUserSelectStatus: UserSelectStatusViewModel? = viewModel.userSelectStatusList
            .first(where: {
                $0.user.id == appConfig.currentUser.id
            })
        return Text(currentUserSelectStatus?.selectedCard?.estimatePoint ?? "")
            .foregroundColor(.gray)
            .font(.title)
    }

    /// ボタンの説明テキスト
    private var buttonText: some View {
        Text(viewModel.isSelectedCardListShown ? "カード選択画面に戻る" : "全員の選択されたカードを見る")
            .foregroundColor(.gray)
            .font(.subheadline)
    }

    /// フローティングアクションボタン
    private var floatingActionButton: some View {
        let selectedCardCount: Int = viewModel.userSelectStatusList.map { $0.selectedCard }.count
        let sfImageName: String = {
            if viewModel.isSelectedCardListShown {
                return "gobackward"
            } else {
                if selectedCardCount >= 3 {
                    return "person.3.sequence"
                } else if selectedCardCount == 2 {
                    return "person.2"
                } else {
                    return "person"
                }
            }
        }()
        
        return Button {
            if viewModel.isSelectedCardListShown {
                dependency.presenter.didTapBackButton()
            } else {
                dependency.presenter.didTapOpenSelectedCardListButton()
            }
        } label: {
            Image(systemName: sfImageName).foregroundColor(.gray)
        }
        .softButtonStyle(Circle())
        .padding(16)
    }

    /// 通知バナー
    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isBannerShown, viewModel: viewModel.bannerMessgage)
    }
}

// MARK: - ModuleAssembler

extension CardListView: ModuleAssembler {
    /// 設定画面へ遷移させるナビゲーション
    private var navigationForSettingView: some View {
        NavigationLink(
            isActive: $viewModel.willPushSettingView,
            destination: {
                assembleSettingModule()
                .onDisappear {
                    let isUserSignedOut: Bool =
                        (LocalStorage.shared.currentRoomId == 0
                            && LocalStorage.shared.currentUserId == "")
                    if isUserSignedOut {
                        // サインアウトしている場合、ルート(=ひとつ前の画面)に遷移する
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        ) { EmptyView() }
    }
}
