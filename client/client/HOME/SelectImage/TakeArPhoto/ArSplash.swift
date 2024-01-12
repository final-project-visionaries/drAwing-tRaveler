import SwiftUI
import RealityKit
import ARKit

struct ArSplash : View {
    @StateObject var locationManager = LocationManager()
    @State private var isActive = false
    @State private var count = 5
    
    var body: some View {
        if isActive{
            TakeArPhotoView().environmentObject(locationManager)
        } else {
            ZStack{
                ARViewContainer3()
                    .ignoresSafeArea()
                    .onDisappear{
                        ARVariables3.dismantleUIView(ARVariables3.arView, coordinator: ())//ARセッション停止
                    }
                
                ZStack{
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.black).opacity(0.5)
                        .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
                    VStack{
                        Text("とりたいほうこうにむけよう!").font(.title).foregroundStyle(.white)
                        Text("\(self.count)").font(.largeTitle).foregroundStyle(.white)
                        Image(systemName: "camera").resizable().scaledToFit()
                            .frame(width:120, height:120).font(.title).foregroundStyle(.white)
                    }
                }
                .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
                        self.count -= 1
                        if self.count == 0 {
                            timer.invalidate()
                            self.isActive.toggle()
                        }
                    }
                }
                
            } // ZStack
            .customBackButton()
        }
    }
}

struct ARVariables3{
    static var arView: ARView!
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
    }
}

struct ARViewContainer3: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        ARVariables3.arView = ARView(frame: .zero)
        return ARVariables3.arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}
