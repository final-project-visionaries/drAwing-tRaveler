import SwiftUI

struct SelectImageView: View {
    @EnvironmentObject var data : ImageData
    
    var body: some View {
        ZStack{
            Image("sky").edgesIgnoringSafeArea(.all)
            
            Rectangle().fill(Color.black.opacity(0.1)).frame(width: 1200, height: 200)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:10){//LazyHStack
                    ForEach(0 ..< data.AllImages.count, id: \.self){ i in
                        VStack{
                            Image(uiImage: data.AllUIImages[i]).resizable().scaledToFit().frame(height: 130)
                                .onTapGesture {
                                    data.SelectedImages[i].toggle()
                                    print("No.\(i) : \(data.SelectedImages)")
                                }
                                .clipped().shadow(color: Color.black, radius: 5, x: 5, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.pink, lineWidth: data.SelectedImages[i] ? 5 : 0)
                                )
                                .scaleEffect(data.SelectedImages[i] ? 1.2 : 1.0)
                            Text("\(i+1) : \(data.AllImages[i].image_name)")
                                .font(.title).fontWeight(.bold).padding(.top).foregroundColor(.black)
                        }
                    }.padding(.horizontal, 40)
                }.frame(width: CGFloat(data.AllImages.count) * 400, height: 220)
            }
            
            HStack{
                ForEach(0 ..< data.SelectedImages.count, id: \.self){ i in
                    if data.SelectedImages[i] == true {
                        Image(uiImage: data.AllUIImages[i]).resizable().scaledToFit().frame(height: 40).padding(10)
                    }
                }
            }
            .background(Color.pink.opacity(0.1))
            .cornerRadius(10)
            .frame(maxWidth: UIScreen.main.bounds.size.width,
                   maxHeight: UIScreen.main.bounds.size.height,
                   alignment: .bottom)
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: TakeArPhotoView()){
                    Image(systemName: "checkmark.circle.fill").imageScale(.large).foregroundStyle(.white)
                    Text("ARを表示").foregroundStyle(.white).padding(.trailing)
                }.background(.green).font(.body.bold()).cornerRadius(5)
            }
        }
    }
}

//#Preview(traits: PreviewTrait.landscapeLeft) {
//    //#Preview {
//    SelectImageView()
//}
