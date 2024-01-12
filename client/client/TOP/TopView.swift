import SwiftUI
import AVFoundation

struct TopView: View {
    @StateObject var imageData = ImageData()
    @State var isLoginView = false
    @State var isRegisterView = false
//    @State private var isActive = false
//    @State private var opacity = 0.1
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("sky3").resizable()
                    .scaledToFit()
                    .frame(width: 1400, height: 600)
                    .clipShape(Rectangle())
                
                VStack(spacing:50){
                    Image("appname_new").resizable().scaledToFit()
                        .frame(maxWidth: UIScreen.main.bounds.size.width)
                        .padding(.top, 30)
                    HStack(spacing:90){
                        
                        VStack{
                            Image("crayon-rd").resizable().scaledToFit()
                                .frame(width: 150, height: 150)
                            Image("label_toHome").resizable()
                                .scaledToFit().frame(width: 300, height: 30)
                        }
                        .onTapGesture {
                            PlaySound.instance.playSound(filename: "top")
                            isLoginView.toggle()
                        }
                        .navigationDestination(isPresented: $isLoginView){LoginMainView()}
                        
                        VStack{
                            Image("greeting").resizable().scaledToFit()
                                .frame(width: 150, height: 150)
                            Image("label_toRegister").resizable()
                                .scaledToFit().frame(width: 300, height: 30)
                        }
                        .onTapGesture {
                            PlaySound.instance.playSound(filename: "top")
                            isRegisterView.toggle()
                        }
                        .navigationDestination(isPresented: $isRegisterView){RegisterMainView()}
                    }
                }
            }
        }
        .environmentObject(imageData)
    }
}
