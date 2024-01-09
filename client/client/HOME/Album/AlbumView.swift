import SwiftUI
import MapKit

struct AlbumView: View {
    @EnvironmentObject var imageData : ImageData
    @State var pos: MapCameraPosition = .automatic
    @State private var pin = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    var body: some View {
        ZStack{
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(0..<imageData.AllAlbums.count, id: \.self){ i in
                        VStack{
                            Image(uiImage: imageData.AllUIAlbums[i]).resizable().scaledToFit().frame(height: 150, alignment: .center)
                        }
                        .onTapGesture {
                            imageData.SelectedAlbums[i].toggle()
                            PlaySound.instance.playSound(filename: "car")
                            pin = CLLocationCoordinate2D( // データがなければ大阪駅の緯度経度を代入
                                latitude:  imageData.AllAlbums[i].album_latitude ?? 34.7022887,
                                longitude: imageData.AllAlbums[i].album_longitude ?? 135.4953509)
                            pos = .region(MKCoordinateRegion(center: pin, latitudinalMeters: 60000, longitudinalMeters: 60000))
                        }
                        .sheet(isPresented: $imageData.SelectedAlbums[i]){
                            ZStack{
                                Image(uiImage: imageData.AllUIAlbums[i]).resizable().scaledToFit()
                                    .frame(maxWidth: UIScreen.main.bounds.size.width * 4 / 5,
                                           maxHeight: UIScreen.main.bounds.size.height  * 4 / 5,
                                           alignment: .leading)
                                VStack{//拡大画像のシートから戻るための矢印ボタン
                                    HStack{
                                        Button(
                                            action: {
                                                imageData.SelectedAlbums[i].toggle()
                                                PlaySound.instance.playSound(filename: "top")
                                            }, label: { Image(systemName: "arrow.backward") }
                                        ).tint(.blue).font(.title).fontWeight(.bold).padding(10)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                
                                VStack{ Spacer()
                                    HStack{ Spacer()
                                        Map(position: $pos){ Marker("", coordinate: pin).tint(.red) }
                                            .frame(width: 200, height: 200)
                                            .clipShape(Circle())
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            
            if imageData.AllAlbums == [] {
                LoadingView()
            }
            
        } // ZStack
        .background(
            RadialGradient(gradient: Gradient(colors: [.yellow, .green]), center: .center, startRadius: 1, endRadius: 300)
        )
        .navigationTitle("🍎 アルバム")
        .customBackButton()
    }
}

