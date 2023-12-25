import SwiftUI

struct HomeView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var isCameraPresented = false
    
    var body: some View {
        ZStack{
            Image("sky4").resizable()
                .scaledToFit()
                .frame(width: 1400, height: 600)
                .clipShape(Rectangle())
            VStack(spacing:-10){
                HStack (spacing : 80) {
                    NavigationLink(destination: DrawingView()){
                        VStack{
                            Image("drawing")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                            Image("label_drawing").resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 30)
                        }
                    }
                    NavigationLink(destination: AlbumView()){
                        VStack{
                            Image("album")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                            Image("label_album").resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 30)
                        }
                    }
                }
                HStack (spacing : 80){
                    Button(action: {
                        isCameraPresented = true
                    }) {
                        VStack(spacing:-10){
                            Image("photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                            Image("label_photo").resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 30)
                        }
                    }
                    .fullScreenCover(isPresented: $isCameraPresented, content: {
                        TakePhotoView()
                    })
                    NavigationLink(destination: SelectImageView()){
                        VStack(spacing:-10){
                            Image("takearphoto")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(30)
                            Image("label_arphoto").resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 30)
                        }
                    }
                }
            }
        }
        .customBackButton()
        .onAppear{
            imageData.SetImages() // データベースのデータを取得、アプリのステート管理をしている変数を初期化
        }
    }
}

//#Preview(traits: PreviewTrait.landscapeLeft){
//  HomeView().environmentObject(ImageData())
//}
