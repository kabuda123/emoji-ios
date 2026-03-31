import Foundation

final class AppEnvironment: ObservableObject {
    let apiClient: APIClient
    let sessionStore: SessionStore

    init(
        apiClient: APIClient = APIClient(),
        sessionStore: SessionStore = SessionStore()
    ) {
        self.apiClient = apiClient
        self.sessionStore = sessionStore
    }
}