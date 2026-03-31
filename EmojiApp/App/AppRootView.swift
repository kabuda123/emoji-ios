import SwiftUI

struct AppRootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TemplateListView()
            }
            .tabItem {
                Label("模板", systemImage: "sparkles")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("历史", systemImage: "clock.arrow.circlepath")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("设置", systemImage: "gearshape")
            }
        }
    }
}