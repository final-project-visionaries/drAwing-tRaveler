import SwiftUI
import MapKit

struct AlbumView: View {
    @EnvironmentObject var imageData : ImageData
    @State var pos: MapCameraPosition = .automatic
    @State private var pin = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    
    @State private var showingAlert = false // Delete
    @State private var item: Int = 0 // Delete
    
    
    var body: some View {
        ZStack{
            Image("sky4").resizable()
                .scaledToFit()
                .frame(width: 1400, height: 600)
                .clipShape(Rectangle())
            
            ScrollView(showsIndicators: false) {
                Image("albumtag").resizable().aspectRatio(contentMode: .fit).frame(width: 150)
                
                LazyVGrid(columns: columns){
                    ForEach(0..<imageData.AllAlbums.count, id: \.self){ i in
                        HStack{
                            Image(uiImage: imageData.AllUIAlbums[i]).resizable().scaledToFit().frame(height: 150, alignment: .center)
                            //                        }
                                .onTapGesture {
                                    imageData.SelectedAlbums[i].toggle()
                                    PlaySound.instance.playSound(filename: "selectImage")
                                    pin = CLLocationCoordinate2D(
                                        //                                latitude: 43.068564 , longitude: 141.3507138) // Sapporo
                                        latitude:  imageData.AllAlbums[i].album_latitude  ?? 34.7022887 ,
                                        longitude: imageData.AllAlbums[i].album_longitude ?? 135.4953509) // nil -> Osaka
                                    pos = .region(MKCoordinateRegion(center: pin, latitudinalMeters: 600000, longitudinalMeters: 600000))
                                }
                                .sheet(isPresented: $imageData.SelectedAlbums[i]){
                                    ZStack{
                                        
                                        Image("sky4").resizable()
                                            .scaledToFit()
                                            .frame(width: 1400, height: 600)
                                            .clipShape(Rectangle())
                                        
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
                                                    ).tint(.blue).font(.title).fontWeight(.bold).padding(15)
                                                    Spacer()
                                                }
                                                Spacer()
                                            } // back
                                            
                                            VStack{ Spacer()
                                                HStack{ Spacer()
                                                    Map(position: $pos){ Marker("", coordinate: pin).tint(.red) }
                                                        .frame(maxWidth: UIScreen.main.bounds.size.width * 0.2)
                                                        .clipShape(Circle())
                                                }
                                            } // map
                                        }.frame(width: UIScreen.main.bounds.size.width*0.9, height: UIScreen.main.bounds.size.height*0.9)
                                        
                                    }
                                }
                            
//                            VStack{
//                                Spacer()
                                Image(systemName: "x.circle.fill")
                                    .resizable().scaledToFit().frame(height: 30)
                                    .foregroundColor(.black)
                                    .offset(x:0, y:-20)
                                    .onTapGesture {
                                        showingAlert.toggle()
                                        item = i
                                        print("tap : \(i)")
                                    }
                                    .alert(isPresented: $showingAlert){
                                        Alert(
                                            title: Text("\(imageData.AllAlbums[item].album_name)"),
                                            message: Text("本当に削除しますか?"),
                                            primaryButton: .destructive(Text("削除する")){
                                                print("delete : \(item)")
                                                let temp_id = imageData.AllAlbums[item].id
                                                Task{
                                                    let result = await apiAlbumDeleteRequest(albumID:temp_id)
                                                    print("API : \(result)")
                                                    imageData.SetAlbums()
                                                }
                                            },
                                            secondaryButton: .cancel(Text("キャンセル"))
                                        )
                                    }
//                            } // Delete
                        }
                        
                    }
                }
            }.frame(width: UIScreen.main.bounds.size.width*0.9, height: UIScreen.main.bounds.size.height*0.9)
            
            if imageData.AllAlbums == [] {
                LoadingView()
            }
        }
        .customBackButton()
        .onAppear{
            imageData.SetAlbums()
        }
    }
}

