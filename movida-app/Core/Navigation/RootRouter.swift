import SwiftUI


struct RootRouter: View {
    @State private var path = NavigationPath()
    @StateObject private var themeManager = AppThemeManager()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if isLoggedIn {
                    DashboardView(
                        navigationPath: $path,
                        onSignOut: { isLoggedIn = false }
                    )
                } else {
                    LoginView(onLoginSuccess: { isLoggedIn = true })
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .detail(let id):
                    DetailMovieView(navigationPath: $path, movieId: id)
                }
            }
        }
        .preferredColorScheme(themeManager.colorScheme)
        .environmentObject(themeManager)
    }
}


enum AppRoute: Hashable {
    case detail(String)
}
