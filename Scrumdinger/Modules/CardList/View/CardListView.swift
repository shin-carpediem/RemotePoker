import Neumorphic
import SwiftUI

struct CardListView: View, ModuleAssembler {
    @Environment(\.presentationMode) var presentation

    // MARK: - Dependency

    struct Dependency {
        var presenter: CardListPresentation
        var roomId: Int
        var currentUserId: String
        var cardPackageId: String
    }

    init(dependency: Dependency, viewModel: CardListViewModel) {
        self.dependency = dependency
        self.viewModel = viewModel
        self.dependency.presenter.viewDidLoad()
    }

    // MARK: - Private

    private var dependency: Dependency

    @ObservedObject private var viewModel: CardListViewModel

    private var notificationBanner: NotificationBanner {
        .init(isShown: $viewModel.isShownBanner, message: viewModel.bannerMessgage)
    }

    // MARK: - View

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()
            contentView
            navigationForSettingView
            if viewModel.isShownLoader { Loader() }
        }
        .navigationTitle(viewModel.headerTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: settingButton)
        .modifier(Overlay(isShown: $viewModel.isShownBanner, overlayView: notificationBanner))
        .onAppear { dependency.presenter.viewDidResume() }
        .onDisappear { dependency.presenter.viewDidSuspend() }
    }

    /// コンテンツビュー
    private var contentView: some View {
        VStack {
            ScrollView {
                Spacer()
                if viewModel.isShownSelectedCardList {
                    selectedCardListView
                        .padding()
                } else {
                    cardListView
                        .padding()
                }
            }
            HStack {
                Spacer()
                selectedCardPointView
                Spacer()
                buttonText
                floatingActionButton
            }
        }
    }

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
        let cardList = viewModel.room.cardPackage.cardList
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(cardList) { card in
                let isSelected =
                    (card.id
                        == viewModel.userSelectStatusList.first(where: {
                            $0.user.id == dependency.currentUserId
                        })?.selectedCard?.id)
                CardView(
                    card: card,
                    themeColor: viewModel.room.cardPackage.themeColor,
                    isEnabled: viewModel.isButtonEnabled,
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
            ForEach(viewModel.userSelectStatusList) { userSelectStatus in
                OpenCardView(userSelectStatus: userSelectStatus)
            }
        }
    }

    /// 選択されたカードのポイント
    private var selectedCardPointView: some View {
        let currentUserSelectStatus = viewModel.userSelectStatusList.first(where: {
            $0.user.id == dependency.currentUserId
        })
        let point = currentUserSelectStatus?.selectedCard?.point ?? ""
        return Text(point)
            .foregroundColor(.gray)
            .font(.system(size: 26, weight: .regular))
    }

    /// ボタンの説明テキスト
    private var buttonText: some View {
        Text(viewModel.buttonText)
            .foregroundColor(.gray)
            .font(.system(size: 14, weight: .regular))
    }

    /// フローティングアクションボタン
    private var floatingActionButton: some View {
        Button {
            if viewModel.isShownSelectedCardList {
                dependency.presenter.didTapResetSelectedCardListButton()
            } else {
                dependency.presenter.didTapOpenSelectedCardListButton()
            }
        } label: {
            Image(systemName: viewModel.fabIconName).foregroundColor(.gray)
        }
        .softButtonStyle(Circle())
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .disabled(!viewModel.isButtonEnabled)
    }

    // MARK: - Router

    /// 設定画面へ遷移させるナビゲーション
    private var navigationForSettingView: some View {
        NavigationLink(
            isActive: $viewModel.willPushSettingView,
            destination: {
                assembleSetting(
                    roomId: dependency.roomId,
                    currentUserId: dependency.currentUserId,
                    cardPackageId: dependency.cardPackageId
                )
                .onDisappear {
                    if LocalStorage.shared.currentRoomId == 0 {
                        // ログアウトしている場合、ルート(=ひとつ前の画面)に遷移する
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        ) { EmptyView() }
    }
}

// MARK: - Preview

struct CardListView_Previews: PreviewProvider {
    static let selectedCardListView: CardListViewModel = {
        let viewModel = CardListViewModel()
        viewModel.userSelectStatusList = [
            .init(
                id: "1",
                user: CardListView_Previews.me,
                themeColor: .navy,
                selectedCard: CardView_Previews.card1),
            .init(
                id: "2",
                user: CardListView_Previews.user1,
                themeColor: .indigo,
                selectedCard: CardView_Previews.card2),
        ]
        viewModel.isShownSelectedCardList = true
        return viewModel
    }()

    static let me: User = .init(
        id: "1",
        name: "ロイド フォージャ",
        currentRoomId: 0,
        selectedCardId: "")

    static let user1: User = .init(
        id: "2",
        name: "ヨル フォージャ",
        currentRoomId: 0,
        selectedCardId: "")

    static let user2: User = .init(
        id: "3",
        name: "アーニャ フォージャ",
        currentRoomId: 0,
        selectedCardId: "")

    static let room1: Room = .init(
        id: 1,
        userList: [me],
        cardPackage: .defaultCardPackage)

    static let room2: Room = .init(
        id: 2,
        userList: [me, user1],
        cardPackage: .defaultCardPackage)

    static var previews: some View {
        Group {
            CardListView(
                dependency: .init(
                    presenter: CardListPresenter(),
                    roomId: 1,
                    currentUserId: "1",
                    cardPackageId: "1"),
                viewModel: .init()
            )
            .previewDisplayName("カード一覧画面/ユーザーが自分のみ")

            CardListView(
                dependency: .init(
                    presenter: CardListPresenter(),
                    roomId: 1,
                    currentUserId: "1",
                    cardPackageId: "1"),
                viewModel: .init()
            )
            .previewDisplayName("カード一覧画面/ユーザーが2名以上")

            CardListView(
                dependency: .init(
                    presenter: CardListPresenter(),
                    roomId: 1,
                    currentUserId: "1",
                    cardPackageId: "1"),
                viewModel: selectedCardListView
            )
            .previewDisplayName("選択済みカード一覧画面")
        }
    }
}
