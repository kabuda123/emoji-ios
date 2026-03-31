import SwiftUI

struct GenerationView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("生成任务状态")
                .font(.headline)
            Text("后续将轮询 CREATED / RUNNING / SUCCESS 等状态。")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("生成")
    }
}