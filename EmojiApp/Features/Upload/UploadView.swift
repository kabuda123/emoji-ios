import SwiftUI

struct UploadView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("上传与裁切流程待接入 PhotosUI。")
            Button("选择图片") {}
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .navigationTitle("上传")
    }
}