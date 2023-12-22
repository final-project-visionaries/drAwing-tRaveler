import SwiftUI

struct HomeView: View {
    @State private var isCameraPresented = false
    var body: some View {
        ZStack{
            Image("sky").edgesIgnoringSafeArea(.all)
            VStack{
                HStack (spacing : 200) {
                    NavigationLink(destination: DrawingView()){
                        VStack{
                            Image("drawing")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                )
                            Text("おえかきする").foregroundColor(.black)
                        }
                    }
                    NavigationLink(destination: AlbumView()){
                        VStack{
                            Image("album")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                )
                            Text("あるばむをみる").foregroundColor(.black)
                        }
                    }
                }
                
                HStack (spacing : 200){
                    Button(action: {isCameraPresented = true}) {
                        HStack{
                            VStack{
                                Image("takephoto")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(75)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                    )
                                Text("えのしゃしんをとる")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $isCameraPresented, content: {
                        TakePhotoView()
                    })
                    NavigationLink(destination: SelectImageView()){
                        VStack{
                            Image("takearphoto")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                )
                            Text("けしきとしゃしんをとる").foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}

//#Preview(traits: PreviewTrait.landscapeLeft){
//    HomeView().environmentObject(ImageData())
//}
