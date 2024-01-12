import SwiftUI

struct HomeView: View {
    @EnvironmentObject var imageData : ImageData
    @State var isDrawingView = false
    @State var isAlbumView = false
    @State var isTakePhotoView = false
    @State var isSelectImageView = false
    
    var body: some View {
        ZStack{
            Image("sky4").resizable()
                .scaledToFit()
                .frame(width: 1400, height: 600)
                .clipShape(Rectangle())
            
            VStack(spacing:-10){
                HStack (spacing : 80) {
                    VStack{
                        Image("drawing")
                            .resizable().scaledToFit().frame(width: 140, height: 140)
                        Image("label_drawing")
                            .resizable().scaledToFit().frame(width: 300, height: 30)
                    }
                    .onTapGesture {
                        PlaySound.instance.playSound(filename: "top")
                        isDrawingView.toggle()
                    }
                    .sheet(isPresented: $isDrawingView){DrawingView(isActive: $isDrawingView)}
                    
                    VStack{
                        Image("album")
                            .resizable().scaledToFill().frame(width: 140, height: 140)
                        Image("label_album")
                            .resizable().scaledToFit().frame(width: 300, height: 30)
                    }
                    .onTapGesture {
                        PlaySound.instance.playSound(filename: "top")
                        isAlbumView.toggle()
                    }
                    .navigationDestination(isPresented: $isAlbumView){AlbumView()}
                }
                
                HStack (spacing : 80){
                    VStack(spacing:-10){
                        Image("photo")
                            .resizable().scaledToFit().frame(width: 150, height: 150).cornerRadius(30)
                        Image("label_photo")
                            .resizable().scaledToFit().frame(width: 300, height: 30)
                    }
                    .onTapGesture {
                        PlaySound.instance.playSound(filename: "top")
                        isTakePhotoView.toggle()
                    }
                    .navigationDestination(isPresented: $isTakePhotoView){TakePhotoView()}
                    
                    VStack(spacing:-10){
                        Image("takearphoto")
                            .resizable().scaledToFit().frame(width: 150, height: 150).cornerRadius(30)
                        Image("label_arphoto")
                            .resizable().scaledToFit().frame(width: 300, height: 30)
                    }
                    .onTapGesture {
                        PlaySound.instance.playSound(filename: "top")
                        isSelectImageView.toggle()
                    }
                    .navigationDestination(isPresented: $isSelectImageView){SelectImageView()}
                }
            }
        }
        .customBackButton2() // logout button
        .onAppear{
            imageData.SetImages() // image tableのデータを取得、Imageデータのステート変数を初期化
            imageData.SetAlbums() // album tableのデータを取得、Albumデータのステート変数を初期化
        }
    }
}
