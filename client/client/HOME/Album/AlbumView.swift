import SwiftUI

struct AlbumView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var bools = Array(repeating: false, count: 9)
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns){
                ForEach(0..<imageData.AllAlbums.count, id: \.self){ i in
                    VStack{
                        Image(uiImage: imageData.AllUIAlbums[i]).resizable().scaledToFit()
                            .frame(height: 150, alignment: .center)
                    }
                    .onTapGesture {
                        imageData.SelectedAlbums[i].toggle()
                        PlaySound.instance.playSound(filename: "car")
                    }
                    .sheet(isPresented: $imageData.SelectedAlbums[i]){
                        ZStack{
                            Image(uiImage: imageData.AllUIAlbums[i])
                                .resizable().scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.size.width,
                                       maxHeight: UIScreen.main.bounds.size.height)
                            VStack{//拡大画像のシートから戻るための矢印ボタン
                                HStack{
                                    Button(
                                        action: {
                                            imageData.SelectedAlbums[i].toggle()
                                            PlaySound.instance.playSound(filename: "top")
                                        }, label: {
                                            Image(systemName: "arrow.backward")
                                        }
                                    )
                                    .tint(.blue).font(.title).fontWeight(.bold).padding(10)
                                    Spacer()
                                }
                                Spacer()
                            }
                            
                        }
                    }
                }
            }
        }
        .background(
            RadialGradient(gradient: Gradient(colors: [.yellow, .green]), center: .center, startRadius: 1, endRadius: 300)
        )
        .navigationTitle("🍎 アルバム")
        .customBackButton()
    }
}

