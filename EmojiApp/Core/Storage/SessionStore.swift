import Foundation

final class SessionStore: ObservableObject {
    @Published var accessToken: String?
}