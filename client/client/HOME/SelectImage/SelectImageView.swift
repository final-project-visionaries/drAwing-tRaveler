import SwiftUI

struct SelectImageView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var isDisable: Bool = true
    @State var isTakeArPhotoView = false
    
    var body: some View {
        ZStack{
            Image("sky").edgesIgnoringSafeArea(.all) //全体背景
            
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
                                    PlaySound.instance.playSound(filename: "car")
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
                                .overlay(//クリックした赤枠:スマホサイズに合わせて変化
                                    GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.pink, lineWidth: imageData.SelectedImages[i] ? 5 : 0)
                                            .frame(width: geometry.size.width,
                                                   height: geometry.size.height)
                                    }
                                )
                                .scaleEffect(imageData.SelectedImages[i] ? 1.2 : 1.0)
                        }
                    }.padding(.horizontal, 40)
                }
                .frame(width: CGFloat(imageData.AllImages.count) * UIScreen.main.bounds.size.width * 4 / 7,
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
                    Image(systemName: "checkmark.circle.fill").imageScale(.large).foregroundStyle(.white)
                    Text("しゃしんをとる").foregroundStyle(.white).padding(.trailing)
                }
                .onTapGesture {
                    PlaySound.instance.playSound(filename: "bell")
                    isTakeArPhotoView.toggle()
                }
                .navigationDestination(isPresented: $isTakeArPhotoView){TakeArPhotoView()}
                .background(.blue).font(.body.bold()).cornerRadius(5)
                .opacity(isDisable ? 0.5 : 1.0)
                .disabled(isDisable)//無選択では押せない
            }
        }
    }
}
