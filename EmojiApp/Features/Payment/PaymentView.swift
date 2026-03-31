import SwiftUI

struct PaymentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("点数购买")
                .font(.headline)
            Button("购买点数") {}
                .buttonStyle(PrimaryButtonStyle())
            Button("恢复购买") {}
        }
        .padding()
        .navigationTitle("购买")
    }
}