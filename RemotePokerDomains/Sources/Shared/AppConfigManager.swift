import Model

public struct AppConfig {
    public var currentUser: UserModel
    public var currentRoom: CurrentRoomModel
    
    public init(currentUser: UserModel, currentRoom: CurrentRoomModel) {
        self.currentUser = currentUser
        self.currentRoom = currentRoom
    }
}

public struct AppConfigManager {
    public static var appConfig: AppConfig?
}
