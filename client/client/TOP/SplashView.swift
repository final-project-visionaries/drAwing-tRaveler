import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.1 // splashの画像の透明度(浮き出てくるアニメーション)
    
    var body: some View {
        if isActive{
            TopView()
        } else {
            ZStack{
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(Color.white)
                    .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
                VStack{
                    VStack{
                        Image("splash").resizable().scaledToFit()
                            .frame(width: 400)
                    }
                    .opacity(opacity)
                    .onAppear{
                         PlayBGM.instance.playBGM(filename:"appbgm")
                        withAnimation(.easeIn(duration: 0.5)){
                            self.opacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}
