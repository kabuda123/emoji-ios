import SwiftUI

struct GenerationView: View {
    @EnvironmentObject private var environment: AppEnvironment

    let templateID: String

    @State private var inputObjectKey = "emoji/demo/input.png"
    @State private var count = 2
    @State private var createdResponse: CreateGenerationResponse?
    @State private var generationDetail: GenerationDetail?
    @State private var isSubmitting = false
    @State private var isRefreshing = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Create Task") {
                TextField("Template ID", text: .constant(templateID))
                    .disabled(true)
                TextField("Input Object Key", text: $inputObjectKey)
                    .textInputAutocapitalization(.never)
                Stepper("Image Count: \(count)", value: $count, in: generationRange)

                Button(isSubmitting ? "Creating..." : "Create Generation Task") {
                    Task { await createGeneration() }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isSubmitting || inputObjectKey.isEmpty)
            }

            if let createdResponse {
                Section("Task Summary") {
                    LabeledContent("Task ID", value: createdResponse.taskId)
                    LabeledContent("Status", value: createdResponse.status.displayName)
                    LabeledContent("Poll Interval", value: "\(createdResponse.pollAfterSeconds) sec")

                    Button(isRefreshing ? "Refreshing..." : "Refresh Task Detail") {
                        Task { await refreshDetail(taskID: createdResponse.taskId) }
                    }
                    .disabled(isRefreshing)
                }
            }

            if let generationDetail {
                Section("Task Detail") {
                    LabeledContent("Status", value: generationDetail.status.displayName)
                    LabeledContent("Progress", value: "\(generationDetail.progressPercent)%")

                    if !generationDetail.previewUrls.isEmpty {
                        Text("Preview URLs")
                            .font(.headline)
                        ForEach(generationDetail.previewUrls, id: \.self) { previewURL in
                            Text(previewURL)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if !generationDetail.resultUrls.isEmpty {
                        Text("Result URLs")
                            .font(.headline)
                        ForEach(generationDetail.resultUrls, id: \.self) { resultURL in
                            Text(resultURL)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if let failedReason = generationDetail.failedReason, !failedReason.isEmpty {
                        Text(failedReason)
                            .foregroundStyle(.red)
                    }
                }
            }

            if let errorMessage {
                Section("Error") {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Generation")
    }

    private var generationRange: ClosedRange<Int> {
        let minCount = environment.bootstrapConfig?.generation.minImages ?? 2
        let maxCount = environment.bootstrapConfig?.generation.maxImages ?? 4
        return minCount...maxCount
    }

    @MainActor
    private func createGeneration() async {
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            let request = CreateGenerationRequest(templateId: templateID, inputObjectKey: inputObjectKey, count: count)
            let headers = ["Idempotency-Key": UUID().uuidString]
            let response: CreateGenerationResponse = try await environment.apiClient.post(
                "/api/generations",
                body: request,
                headers: headers
            )
            createdResponse = response
            await refreshDetail(taskID: response.taskId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func refreshDetail(taskID: String) async {
        isRefreshing = true
        errorMessage = nil
        defer { isRefreshing = false }

        do {
            generationDetail = try await environment.apiClient.get("/api/generations/\(taskID)")
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}