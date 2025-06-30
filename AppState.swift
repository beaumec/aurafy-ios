import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
}
