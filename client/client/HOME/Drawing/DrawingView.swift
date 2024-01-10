import SwiftUI
import UIKit
import PencilKit

extension PKCanvasView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        return image
    }
}

struct DrawingView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var canvasView = PKCanvasView()
    @State var selectedColor:Color = .black
    
    var body: some View {
        NavigationView{
            ZStack {
                DrawingView_(canvasView: $canvasView, selectedColor: $selectedColor)
            }
            .onAppear {
                canvasView.drawing = PKDrawing()
            }
        }
        .customBackButton()
        .toolbar { // 右上のボタン
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                VStack {
                    HStack(spacing: 10) {
                        Spacer()
                        ColorPicker("Color", selection: $selectedColor).labelsHidden()
                        Button(action: {
                            canvasView.drawing = PKDrawing()
                        }) {Text("えをけす").foregroundColor(.red)}
                        Button(action: {
                            PKCanvasViewToUIImage()
                            PlaySound.instance.playSound(filename: "camera")
                        }) {Text("えをほぞん")}
                    }
                    .padding(20)
                    Spacer()
                }
            }
        }
    }
    func PKCanvasViewToUIImage(){ // UIImageに変換、圧縮、DBにポスト
        if let image = canvasView.asImage(){
            var sendData: [String:String] = [:]
            sendData["image_name"] = "post from Drawing View"
            sendData["image_data"] = imageData.resizeImageToBase64(image: image)
            Task {
                let res = await apiImagePostRequest(reqBody: sendData)
                print("Drawing POST res : \(res)")
            }
        }
    }
}

struct DrawingView_: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var selectedColor: Color
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = UIColor(red: 255/255, green: 243/255, blue: 210/255, alpha: 1)
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 3.0)
        return canvasView
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = PKInkingTool(.pen, color: UIColor(selectedColor), width: 3.0)
    }
}
