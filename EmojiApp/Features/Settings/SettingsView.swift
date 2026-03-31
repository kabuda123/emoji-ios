import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        List {
            Section("Account") {
                NavigationLink("Login Settings") {
                    AuthView()
                }
                NavigationLink("Purchase Settings") {
                    PaymentView()
                }
            }

            Section("App Config") {
                if environment.isLoadingBootstrap {
                    ProgressView("Loading config...")
                } else if let bootstrap = environment.bootstrapConfig {
                    LabeledContent("Product", value: bootstrap.productName)
                    LabeledContent("Login Methods", value: bootstrap.supportedLoginMethods.joined(separator: ", "))
                    LabeledContent("IAP", value: bootstrap.iapEnabled ? "Enabled" : "Disabled")
                    LabeledContent("Generation Range", value: "\(bootstrap.generation.minImages)-\(bootstrap.generation.maxImages) images")
                }

                if let bootstrapErrorMessage = environment.bootstrapErrorMessage {
                    Text(bootstrapErrorMessage)
                        .foregroundStyle(.red)
                }

                Button("Reload Config") {
                    Task { await environment.reloadBootstrap() }
                }
            }

            Section("Legal") {
                if let bootstrap = environment.bootstrapConfig {
                    ForEach(bootstrap.legalDocuments) { document in
                        if let url = URL(string: document.url) {
                            Link(document.title, destination: url)
                        } else {
                            Text(document.title)
                        }
                    }
                } else {
                    Text("Waiting for bootstrap config")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Session") {
                if let userId = environment.sessionStore.currentUserId {
                    Text("Current user: \(userId)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Button("Clear Local Session", role: .destructive) {
                    environment.sessionStore.clear()
                }
            }
        }
        .navigationTitle("Settings")
        .task {
            await environment.loadBootstrapIfNeeded()
        }
    }
}