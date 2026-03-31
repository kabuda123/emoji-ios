import SwiftUI

struct HistoryView: View {
    var body: some View {
        ContentUnavailableView("暂无历史记录", systemImage: "photo.on.rectangle")
            .navigationTitle("历史")
    }
}