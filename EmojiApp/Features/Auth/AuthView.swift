import SwiftUI

struct AuthView: View {
    var body: some View {
        List {
            Section("登录") {
                Button("Apple 登录") {}
                Button("邮箱验证码登录") {}
            }
        }
        .navigationTitle("登录")
    }
}