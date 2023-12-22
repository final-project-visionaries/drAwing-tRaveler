import SwiftUI

struct TopView: View {
    @StateObject var data = ImageData()
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Text("TOP")//ここで仮置き（TOP画面だとわかるように。）
                    NavigationLink(destination: HomeView()){
                        Image(systemName: "house.fill")
                            .imageScale(.large)
                        Text("ホーム")
                    }
                    Button{
                        data.SetImages() // 非同期処理 -> 初期化
                    } label: {Text("画像データを再取得")}
                    Text("取得された画像データ : \(data.AllImages.count)枚").foregroundStyle(.green)
                    Text("選択されたARモデル : \(data.SelectedImages.filter{ $0 == true }.count)個").foregroundStyle(.red)
                    //                    NavigationLink(destination: LoginEntryView()){
                    //                        //.environmentObject(UserData())) {
                    //                            Image(systemName: "macpro.gen3.fill")
                    //                                .imageScale(.large)
                    //                            Text("ログイン")
                    //                        }
                    //                    NavigationLink(destination: RegisterEntryView()){
                    //                            Image(systemName: "house.fill")
                    //                                .imageScale(.large)
                    //                            Text("新規登録")
                    //                        }
                }
            }
        }
        .environmentObject(data)
        .onAppear{
            data.SetImages() // 非同期処理 -> 初期化
        }
    }
}

//#Preview {
//    TopView()
//}
