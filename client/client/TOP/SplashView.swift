import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.08 // splashの画像のサイズ
    @State private var opacity = 0.1 // splashの画像の透明度(浮き出てくるアニメーションのため)
    
    let bgmPlayer = BgmPlay()
    
    var body: some View {
        if isActive{
            TopView()
        } else {
            VStack{
                VStack{
                    Image("splash")
                        .font(.system(size: 80))
                        .foregroundStyle(.red)
                    Text("ハート Heart")
                        .font(Font.custom("Baskerville-Bold", size: 100))
                        .foregroundStyle(.white.opacity(0.80))
                        .background(.blue)
                        .frame(width: 800)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    // bgmPlayer.play(fileName:"back", extentionName: "mp3")
                    
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.2
                        self.opacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self.isActive = true
                    }
                }
            }
            .background(.black)
        }
    }
}
