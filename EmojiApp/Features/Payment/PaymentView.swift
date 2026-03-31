import SwiftUI

struct PaymentView: View {
    @EnvironmentObject private var environment: AppEnvironment

    @State private var balance: CreditBalance?
    @State private var verifyResponse: VerifyIAPResponse?
    @State private var productID = "credits_120"
    @State private var transactionID = "demo-transaction-id"
    @State private var receiptData = "demo-receipt"
    @State private var isLoadingBalance = false
    @State private var isVerifying = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Credit Balance") {
                if let balance {
                    LabeledContent("Available", value: "\(balance.availableCredits)")
                    LabeledContent("Frozen", value: "\(balance.frozenCredits)")
                    LabeledContent("Unit", value: balance.currency)
                } else if isLoadingBalance {
                    ProgressView("Loading balance...")
                }

                Button("Reload Balance") {
                    Task { await loadBalance() }
                }
            }

            Section("IAP Verification") {
                TextField("Product ID", text: $productID)
                TextField("Transaction ID", text: $transactionID)
                TextField("Receipt Data", text: $receiptData)

                Button(isVerifying ? "Verifying..." : "Verify Purchase") {
                    Task { await verifyIAP() }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isVerifying || productID.isEmpty || transactionID.isEmpty || receiptData.isEmpty)
            }

            if let verifyResponse {
                Section("Verification Result") {
                    LabeledContent("Order ID", value: verifyResponse.orderId)
                    LabeledContent("Status", value: verifyResponse.status)
                    LabeledContent("Granted", value: "\(verifyResponse.creditsGranted)")
                    LabeledContent("Balance After", value: "\(verifyResponse.balanceAfter)")
                }
            }

            if let errorMessage {
                Section("Error") {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Purchase")
        .task {
            await loadBalanceIfNeeded()
        }
    }

    @MainActor
    private func loadBalanceIfNeeded() async {
        guard balance == nil else { return }
        await loadBalance()
    }

    @MainActor
    private func loadBalance() async {
        isLoadingBalance = true
        errorMessage = nil
        defer { isLoadingBalance = false }

        do {
            balance = try await environment.apiClient.get("/api/credits/balance")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func verifyIAP() async {
        isVerifying = true
        errorMessage = nil
        defer { isVerifying = false }

        do {
            verifyResponse = try await environment.apiClient.post(
                "/api/iap/verify",
                body: VerifyIAPRequest(productId: productID, transactionId: transactionID, receiptData: receiptData)
            )
            await loadBalance()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}