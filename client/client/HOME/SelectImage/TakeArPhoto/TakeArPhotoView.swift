import SwiftUI

struct TakeArPhotoView: View {
    @EnvironmentObject var data : ImageData
    
    var body: some View {
        Text("AR表示をして写真を撮る")
        Text("取得された画像データ : \(data.AllImages.count)枚").foregroundStyle(.green)
        Text("選択されたARモデル : \(data.SelectedImages.filter{ $0 == true }.count)個").foregroundStyle(.red)
        HStack{
            ForEach(0 ..< data.AllImages.count, id: \.self){ i in
                if data.SelectedImages[i] == true {
                    VStack{
                        Image(uiImage: data.AllUIImages[i]).resizable().scaledToFit().frame(height: 100)
                        Text("\(i+1) : \(data.AllImages[i].image_name)")
                            .font(.caption).fontWeight(.bold).padding(.top).foregroundColor(.blue)
                    }
                }
            }.padding(.horizontal, 40)
        }
    }
}

//#Preview {
//    TakeArPhotoView()
//}
