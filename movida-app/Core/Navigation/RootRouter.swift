import SwiftUI

struct RootRouter: View {
    @State private var path = NavigationPath()
    @StateObject private var themeManager = AppThemeManager()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if isLoggedIn {
                    DashboardView(navigationPath: $path)
                } else {
                    LoginView(onLoginSuccess: {
                        isLoggedIn = true
                    })
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .detail(let id):
                    DetailMovieView(movieId: id)
                }
            }
        }
    }
}


enum AppRoute: Hashable {
    case detail(String)
}
