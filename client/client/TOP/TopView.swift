import SwiftUI
import AVFoundation

let musicData = NSDataAsset(name: "top")!.data
var musicPlayer:AVAudioPlayer!

struct TopView: View {
    @StateObject var imageData = ImageData()
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("sky3").resizable()
                    .scaledToFit()
                    .frame(width: 1400, height: 600)
                    .clipShape(Rectangle())
                VStack(spacing:50){
                    Image("appname4")
                    HStack(spacing:90){
                        
                        NavigationLink(destination: HomeView()){
                            VStack{
                                Image("crayon-rd").resizable().scaledToFit()
                                    .frame(width: 150, height: 150)
                                Image("label_toHome").resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 30)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            do{
                                musicPlayer = try AVAudioPlayer(data: musicData)
                                musicPlayer.play()
                            }catch{
                                print("音の再生に失敗しました。")
                            }
                        })
                        
                        NavigationLink(destination: RegisterEntryView()){
                            VStack{
                                Image("greeting").resizable().scaledToFit()
                                    .frame(width: 150, height: 150)
                                Image("label_toRegister").resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 30)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            do{
                                musicPlayer = try AVAudioPlayer(data: musicData)
                                musicPlayer.play()
                            }catch{
                                print("音の再生に失敗しました。")
                            }
                        })
                        
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
