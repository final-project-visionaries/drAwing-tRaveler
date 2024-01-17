import SwiftUI

struct SelectImageView: View {
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var imageData : ImageData
    @State private var isDisable: Bool = true
    @State var isArSplash = false
    
    @State private var showingAlert = false // Delete
    @State private var item: Int = 0 // Delete
    
    var body: some View {
        ZStack{
            Image("sky4").resizable()
                .scaledToFit()
                .frame(width: 1400, height: 600)
                .clipShape(Rectangle())
            
            Rectangle()//スクロール背景:スマホサイズに合わせて変化
                .fill(Color.black.opacity(0.1))
                .frame(width: UIScreen.main.bounds.size.width * 2,
                       height: UIScreen.main.bounds.size.height * 3 / 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing:10){
                    ForEach(0 ..< imageData.AllImages.count, id: \.self){ i in
                        VStack{
                            Image(uiImage: imageData.AllUIImages[i]).resizable().scaledToFit()
                            //.frame(height: UIScreen.main.bounds.size.height * 2 / 5)
                                .frame(width: 200)
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
                                .overlay(
                                    GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: 7)
                                            .stroke(Color.pink, lineWidth: imageData.SelectedImages[i] ? 7 : 0)
                                            .frame(width: geometry.size.width,
                                                   height: geometry.size.height)
                                    }
                                )//クリックした赤枠
                                .scaleEffect(imageData.SelectedImages[i] ? 1.2 : 1.0)
                            Spacer()
                            Image(systemName: "x.circle.fill")
                                .resizable().scaledToFit().frame(height: 30)
                                .foregroundColor(.black)
                            //.offset(x:0, y:-20)
                                .onTapGesture {
                                    showingAlert.toggle()
                                    item = i
                                    print("tap : \(i)")
                                }
                                .alert(isPresented: $showingAlert){
                                    Alert(
                                        title: Text("\(imageData.AllImages[item].image_name)"),
                                        message: Text("本当に削除しますか?"),
                                        primaryButton: .destructive(Text("削除する")){
                                            print("delete : \(item)")
                                            let temp_id = imageData.AllImages[item].id
                                            Task{
                                                let result = await apiImageDeleteRequest(imageID:temp_id)
                                                print("API : \(result)")
                                                imageData.SetImages()
                                            }
                                        },
                                        secondaryButton: .cancel(Text("キャンセル"))
                                    )
                                } // Delete
                        }
                        
                    }
                }//.padding(.horizontal, 40)
                //.frame(width: CGFloat(imageData.AllImages.count) * UIScreen.main.bounds.size.width * 0.65,
                .frame(width: CGFloat(imageData.AllImages.count) * 230,
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
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack{
                    Image("takepic").resizable().aspectRatio(contentMode: .fit).frame(width: 150)
                        .background(Color.green, in: RoundedRectangle(cornerRadius: 5))
                }
                .onTapGesture {
                    PlaySound.instance.playSound(filename: "top")
                    isArSplash.toggle()
                }
                .navigationDestination(isPresented: $isArSplash){ArSplash().environmentObject(locationManager)}
                .font(.body.bold()).cornerRadius(5)
                .opacity(isDisable ? 0.5 : 1.0)
                .disabled(isDisable)//無選択では押せない
            }
        }// 右上のボタン
        .onAppear{
            imageData.SetImages()
        }
        .onDisappear{
            imageData.SelectedImages = Array(repeating: false, count: imageData.AllImages.count)
            imageData.AllImages = []
        }
    }
}
