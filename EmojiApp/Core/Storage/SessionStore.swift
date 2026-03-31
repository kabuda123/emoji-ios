import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var currentSession: AuthSession?

    var accessToken: String? {
        currentSession?.accessToken
    }

    var currentUserId: String? {
        currentSession?.userId
    }

    func update(session: AuthSession) {
        currentSession = session
    }

    func clear() {
        currentSession = nil
    }
}