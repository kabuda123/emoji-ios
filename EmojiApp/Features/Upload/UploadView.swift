import SwiftUI

struct UploadView: View {
    @EnvironmentObject private var environment: AppEnvironment

    @State private var fileName: String
    @State private var contentType = "image/png"
    @State private var uploadPolicy: UploadPolicy?
    @State private var isLoading = false
    @State private var errorMessage: String?

    init(defaultFileName: String = "demo.png") {
        _fileName = State(initialValue: defaultFileName)
    }

    var body: some View {
        Form {
            Section("Request") {
                TextField("File Name", text: $fileName)
                TextField("Content-Type", text: $contentType)
                    .textInputAutocapitalization(.never)
            }

            Section {
                Button(isLoading ? "Requesting..." : "Request Upload Policy") {
                    Task { await requestUploadPolicy() }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isLoading || fileName.isEmpty || contentType.isEmpty)
            }

            if let uploadPolicy {
                Section("Response") {
                    LabeledContent("Object Key", value: uploadPolicy.objectKey)
                    LabeledContent("Method", value: uploadPolicy.method)
                    LabeledContent("Expires In", value: "\(uploadPolicy.expiresInSeconds) sec")
                    Text(uploadPolicy.uploadUrl)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            if let errorMessage {
                Section("Error") {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Upload")
    }

    @MainActor
    private func requestUploadPolicy() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            uploadPolicy = try await environment.apiClient.post(
                "/api/upload/policy",
                body: UploadPolicyRequest(fileName: fileName, contentType: contentType)
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}