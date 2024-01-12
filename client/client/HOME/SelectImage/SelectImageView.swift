import SwiftUI

struct SelectImageView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var isDisable: Bool = true
    @State var isArSplash = false
    
    var body: some View {
        ZStack{
            Image("sky").ignoresSafeArea()
            
            Rectangle()//スクロール背景:スマホサイズに合わせて変化
                .fill(Color.black.opacity(0.1))
                .frame(width: UIScreen.main.bounds.size.width * 2,
                       height: UIScreen.main.bounds.size.height * 3 / 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:10){
                    ForEach(0 ..< imageData.AllImages.count, id: \.self){ i in
                        HStack{
                            Image(uiImage: imageData.AllUIImages[i]).resizable().scaledToFit()
                                .frame(height: UIScreen.main.bounds.size.height * 2 / 5)
                                .onTapGesture {
                                    PlaySound.instance.playSound(filename: "selectImage")
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
                                .overlay(//クリックした赤枠
                                    GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: 7)
                                            .stroke(Color.pink, lineWidth: imageData.SelectedImages[i] ? 7 : 0)
                                            .frame(width: geometry.size.width,
                                                   height: geometry.size.height)
                                    }
                                )
                                .scaleEffect(imageData.SelectedImages[i] ? 1.2 : 1.0)
                        }
                    }.padding(.horizontal, 40)
                }
                .frame(width: CGFloat(imageData.AllImages.count) * UIScreen.main.bounds.size.width * 0.65,
                       height: UIScreen.main.bounds.size.height * 3 / 5)
            }
            
            // mini
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
            .padding(.bottom, 30)// mini
            
            if imageData.AllImages == [] {
                LoadingView()
            }
            
        }//ZStack
        .customBackButton()
        .ignoresSafeArea()
        .toolbar {// 右上のボタン
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack{
                    Image("takepic").resizable().aspectRatio(contentMode: .fit).frame(width: 150)
                        .background(Color.green, in: RoundedRectangle(cornerRadius: 5))
                }
                .onTapGesture {
                    PlaySound.instance.playSound(filename: "top")
                    isArSplash.toggle()
                }
                .navigationDestination(isPresented: $isArSplash){ArSplash()}
                .font(.body.bold()).cornerRadius(5)
                .opacity(isDisable ? 0.5 : 1.0)
                .disabled(isDisable)//無選択では押せない
            }
        }
        .onAppear{
            imageData.SetImages()
        }
        .onDisappear{
            imageData.SelectedImages = Array(repeating: false, count: imageData.AllImages.count)
            imageData.AllImages = []
        }
    }
}
