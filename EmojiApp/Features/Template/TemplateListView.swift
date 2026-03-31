import SwiftUI

struct TemplateListView: View {
    private let placeholders = [
        Template(id: "comic", name: "漫画风", previewURL: nil),
        Template(id: "sticker", name: "贴纸风", previewURL: nil)
    ]

    var body: some View {
        List(placeholders) { template in
            NavigationLink(value: template.id) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(template.name)
                        .font(.headline)
                    Text("占位模板，后续接入服务端模板接口。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("模板")
    }
}