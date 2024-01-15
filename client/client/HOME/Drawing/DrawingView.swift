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

struct LimitedColorPicker: View {
    let colors: [Color]
    @Binding var selectedColor: Color
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    selectedColor = color
                }) {
                    color
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: selectedColor == color ? 3 : 0)
                        )
                }
            }
        }
    }
}

struct DrawingView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var canvasView = PKCanvasView()
    @State var selectedColor:Color = .black
    @State private var isSaved = false
    @State private var count = 2
    @Binding var isActive:Bool
    
    let limitedColors: [Color] = [.red,.yellow,.orange,.green,.blue,.purple,.brown,.gray,.white,.black]
    var body: some View {
        ZStack {
            DrawingView_(canvasView: $canvasView, selectedColor: $selectedColor)
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 20){
                    Spacer()
                    LimitedColorPicker(colors: limitedColors, selectedColor: $selectedColor).padding(.vertical, 10)
                    Button(action: {
                        canvasView.drawing = PKDrawing()
                    }) {
                        Image("deletepic").resizable().aspectRatio(contentMode: .fit).frame(width: 100)
                            .background(Color.pink, in: RoundedRectangle(cornerRadius: 5))
                    }.padding(.horizontal, 10)
                    Button(action: {
                        PlaySound.instance.playSound(filename: "camera")
                        PKCanvasViewToUIImage()
                        isSaved.toggle()
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
                            self.count -= 1
                            if self.count == 0 {
                                timer.invalidate()
                                self.isSaved.toggle()
                                self.count = 2
                            }
                        }
                    }) {
                        Image("savepic").resizable().aspectRatio(contentMode: .fit).frame(width: 120)
                            .background(Color.cyan, in: RoundedRectangle(cornerRadius: 5))
                    }.padding(.trailing, 20)
                }.padding(10)
                Spacer()
            } // tools
            
            if isSaved == true {
                ZStack{
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.black).opacity(0.5)
                        .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
                    Text("えをほぞんしたよ！").foregroundStyle(.white).font(.title)
                }
            }
            
            VStack{
                HStack(spacing: 20){
                    Button(
                        action: {
                            PlaySound.instance.playSound(filename: "top")
                            isActive.toggle()
                        }, label: { Image(systemName: "arrow.backward") }
                    )
                    .tint(.blue).font(.title).fontWeight(.bold)
                    .padding(.leading,50)
                    Spacer()
                }.padding(10)
                Spacer()
            } // back
            
        }
        .onAppear {canvasView.drawing = PKDrawing()}
        .ignoresSafeArea()
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
