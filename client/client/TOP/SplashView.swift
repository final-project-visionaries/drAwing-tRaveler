import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    var body: some View {
        if isActive{
            TopView()
        } else {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color.white)
                .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
                .onAppear{
                    PlayBGM.instance.playBGM(filename:"appbgm")
                    isActive = true
                }
        }
    }
}
