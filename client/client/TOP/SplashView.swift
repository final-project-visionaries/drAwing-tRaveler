import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.08 // splashの画像のサイズ
    @State private var opacity = 0.1 // splashの画像の透明度(浮き出てくるアニメーション)
    
    var body: some View {
        if isActive{
            TopView()
        } else {
            VStack{
                VStack{
                    Image("splash").font(.system(size: 80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    PlayBGM.instance.playBGM(filename:"appbgm")
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.2
                        self.opacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self.isActive = true
                    }
                }
            }
            .background(Color(UIColor(red: 193/255, green: 231/255, blue: 253/255, alpha: 1)))
        }
    }
}
