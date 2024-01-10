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
                            PlaySound.instance.playSound(filename: "selectImage")
                            pin = CLLocationCoordinate2D( // データがなければ大阪駅の緯度経度を代入
                                latitude:  imageData.AllAlbums[i].album_latitude ?? 34.7022887,
                                longitude: imageData.AllAlbums[i].album_longitude ?? 135.4953509)
                            pos = .region(MKCoordinateRegion(center: pin, latitudinalMeters: 60000, longitudinalMeters: 60000))
                        }
                        .sheet(isPresented: $imageData.SelectedAlbums[i]){
                            ZStack{
                                HStack{
                                    Image(uiImage: imageData.AllUIAlbums[i]).resizable().scaledToFit()
                                        .frame(maxWidth: UIScreen.main.bounds.size.width * 0.7,
                                               maxHeight: UIScreen.main.bounds.size.height * 0.7,
                                               alignment: .leading)
                                    Spacer()
                                }
                                
                                VStack{
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
                                } // 拡大画像のシートから戻るための矢印ボタン
                                
                                VStack{ Spacer()
                                    HStack{ Spacer()
                                        Map(position: $pos){ Marker("", coordinate: pin).tint(.red) }
                                            .frame(maxWidth: UIScreen.main.bounds.size.width * 0.2)
                                            .clipShape(Circle())
                                    }
                                } // circle map
                                
                            }.background(Color.orange)
                        }
                    }
                }
            }
            
            if imageData.AllAlbums == [] {
                LoadingView()
            }
            
        }
        .background(Color(UIColor(red: 255/255, green: 243/255, blue: 210/255, alpha: 1)))
        .navigationTitle("🍎 あるばむ")
        .customBackButton()
    }
}

