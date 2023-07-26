import CardListDomain
import EnterRoomDomain
import RemotePokerData
import RemotePokerDomains
import SelectThemeColorDomain
import SettingDomain
import Shared

extension ModuleAssembler {
    public func assmebleEnterRoomModule() -> EnterRoomView {
        let viewModel = EnterRoomViewModel()
        let presenter = EnterRoomPresenter()
        let interactor = EnterRoomInteractor()

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(.init(repository: EnterRoomDataStore(), output: presenter))
        let view = EnterRoomView(
            dependency: .init(presenter: presenter), viewModel: viewModel)

        return view
    }

    public func assembleCardListModule() -> CardListView {
        let viewModel = CardListViewModel()
        let presenter = CardListPresenter()
        let interactor = CardListInteractor()

        var appConfig: AppConfig {
            guard let appConfig = AppConfigManager.appConfig else {
                fatalError()
            }
            return appConfig
        }
        
        presenter.inject(
            .init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                enterRoomRepository: EnterRoomDataStore(),
                currentRoomRepository: CurrentRoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)), output: presenter))
        let view = CardListView(
            dependency: .init(presenter: presenter),
            viewModel: viewModel)

        return view
    }

    public func assembleSettingModule()
        -> SettingView
    {
        let viewModel = SettingViewModel()
        let presenter = SettingPresenter()
        let interactor = SettingInteractor()

        var appConfig: AppConfig {
            guard let appConfig = AppConfigManager.appConfig else {
                fatalError()
            }
            return appConfig
        }

        presenter.inject(.init(useCase: interactor, viewModel: viewModel))
        interactor.inject(
            .init(
                repository: CurrentRoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)),
                output: presenter))
        let view = SettingView(
            dependency: .init(presenter: presenter),
            viewModel: viewModel)

        return view
    }

    public func assembleSelectThemeColorModule()
        -> SelectThemeColorView
    {
        let viewModel = SelectThemeColorViewModel()
        let presenter = SelectThemeColorPresenter()

        var appConfig: AppConfig {
            guard let appConfig = AppConfigManager.appConfig else {
                fatalError()
            }
            return appConfig
        }

        presenter.inject(
            .init(
                repository: CurrentRoomDataStore(userId: appConfig.currentUser.id, roomId: String(appConfig.currentRoom.id)),
                viewModel: viewModel))
        let view = SelectThemeColorView(
            dependency: .init(presenter: presenter), viewModel: viewModel)

        return view
    }
}
