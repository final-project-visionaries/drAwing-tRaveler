import SwiftUI
import AVFoundation

struct TopView: View {
    @StateObject var imageData = ImageData()
    @State var isHomeView = false
    @State var isRegisterEntryView = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("sky3").resizable()
                    .scaledToFit()
                    .frame(width: 1400, height: 600)
                    .clipShape(Rectangle())
                
                VStack(spacing:50){
                    Image("appname4")
                    HStack(spacing:90){
                        
                        VStack{
                            Image("crayon-rd").resizable().scaledToFit()
                                .frame(width: 150, height: 150)
                            Image("label_toHome").resizable()
                                .scaledToFit().frame(width: 300, height: 30)
                        }
                        .onTapGesture {
                            PlaySound.instance.playSound(filename: "top")
                            isHomeView.toggle()
                        }
                        .navigationDestination(isPresented: $isHomeView){HomeView()}
                        
                        VStack{
                            Image("greeting").resizable().scaledToFit()
                                .frame(width: 150, height: 150)
                            Image("label_toRegister").resizable()
                                .scaledToFit().frame(width: 300, height: 30)
                        }
                        .onTapGesture {
                            PlaySound.instance.playSound(filename: "top")
                            isRegisterEntryView.toggle()
                        }
                        .navigationDestination(isPresented: $isRegisterEntryView){RegisterEntryView()}
                        
                    }
                }
            }
        }
        .environmentObject(imageData)
    }
}

//#Preview(traits: PreviewTrait.landscapeLeft) {
//    TopView()
//}
