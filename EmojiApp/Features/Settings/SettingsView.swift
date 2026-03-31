import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink("登录设置") {
                AuthView()
            }
            NavigationLink("购买设置") {
                PaymentView()
            }
            Text("隐私政策")
            Text("用户协议")
            Text("AI 授权说明")
            Text("删除账号")
        }
        .navigationTitle("设置")
    }
}