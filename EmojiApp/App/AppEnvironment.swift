import Foundation

@MainActor
final class AppEnvironment: ObservableObject {
    let apiClient: APIClient
    let sessionStore: SessionStore

    @Published private(set) var bootstrapConfig: BootstrapConfig?
    @Published private(set) var isLoadingBootstrap = false
    @Published var bootstrapErrorMessage: String?

    init(
        apiClient: APIClient = APIClient(),
        sessionStore: SessionStore = SessionStore()
    ) {
        self.apiClient = apiClient
        self.sessionStore = sessionStore
        self.apiClient.accessTokenProvider = { [weak sessionStore] in
            sessionStore?.accessToken
        }
    }

    func loadBootstrapIfNeeded() async {
        if bootstrapConfig != nil || isLoadingBootstrap {
            return
        }
        await reloadBootstrap()
    }

    func reloadBootstrap() async {
        isLoadingBootstrap = true
        bootstrapErrorMessage = nil
        defer { isLoadingBootstrap = false }

        do {
            bootstrapConfig = try await apiClient.get("/api/config/bootstrap")
        } catch {
            bootstrapErrorMessage = error.localizedDescription
        }
    }
}