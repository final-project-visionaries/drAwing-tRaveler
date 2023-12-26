import SwiftUI


struct SelectImageView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var isDisable: Bool = true
    
    var body: some View {
        ZStack{
            Image("sky").edgesIgnoringSafeArea(.all) //全体背景
            
            Rectangle().fill(Color.black.opacity(0.1)).frame(width: 1200, height: 220) //スクロール背景
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:10){
                    ForEach(0 ..< imageData.AllImages.count, id: \.self){ i in
                        HStack{
                            Image(uiImage: imageData.AllUIImages[i]).resizable().scaledToFit().frame(height: 130)
                                .onTapGesture {
                                    SoundManager.instance.playSound(sound: "car", withExtension: "mp3")
                                    imageData.SelectedImages[i].toggle()
                                    print("選択された画像 : \(i), トータル : \(imageData.SelectedImages.filter{ $0 == true }.count)枚")
                                    imageData.SetArModels()
                                    if imageData.ArModels.isEmpty {
                                        isDisable = true
                                    } else {
                                        isDisable = false
                                    }
                                }
                                .clipped().shadow(color: Color.black, radius: 5, x: 5, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.pink, lineWidth: imageData.SelectedImages[i] ? 5 : 0)
                                )
                                .scaleEffect(imageData.SelectedImages[i] ? 1.2 : 1.0)
                        }
                    }.padding(.horizontal, 20)
                }.frame(width: CGFloat(imageData.AllImages.count) * 400, height: 220)
            }
            
            // ミニ画像
            HStack(spacing:0){
                ForEach(0 ..< imageData.SelectedImages.count, id: \.self){ i in
                    if imageData.SelectedImages[i] == true {
                        Image(uiImage: imageData.AllUIImages[i]).resizable().scaledToFit()
                            .frame(height: 40).padding(10)
                    }
                }
            }
            .background(Color.pink.opacity(0.1))
            .cornerRadius(10)
            .frame(maxWidth: UIScreen.main.bounds.size.width,
                   maxHeight: UIScreen.main.bounds.size.height,
                   alignment: .bottom)
            .padding(.bottom, 30)
            
        }
        .customBackButton()
        .ignoresSafeArea()
        .toolbar {// 右上のボタン
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: TakeArPhotoView()){
                    Image(systemName: "checkmark.circle.fill").imageScale(.large).foregroundStyle(.white)
                    Text("ARをうつす").foregroundStyle(.white).padding(.trailing)
                }
                .background(.green).font(.body.bold()).cornerRadius(5)
                .opacity(isDisable ? 0.5 : 1.0)
                .disabled(isDisable)//無選択では押せない
            }
        }
        .onAppear{
            SoundManager.instance.playSound(sound: "bell", withExtension: "mp3")
        }
    }
}

////#Preview(traits: PreviewTrait.landscapeLeft) {
//    #Preview {
//    SelectImageView()
//}
