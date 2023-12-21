
import SwiftUI

struct SelectImageView: View {
    
    @State private var activie = false
    var body: some View {
                
        ZStack{
            Image("sky").edgesIgnoringSafeArea(.all)
            ScrollView(.horizontal, showsIndicators: false)  {
                HStack(spacing:100){
                    NavigationLink(destination: TakeArPhotoView()){
                        Image(systemName: "house.fill")
                            .imageScale(.large)
                        Text("ARを表示")
                    }
                    ForEach(0 ..< 10, id: \.self){ index in
                        Text("AR--- \(index)").font(.title)
                        Image("pic1")
                    }
                }
                .frame(width: 7000)
//                .offset(x:200)
            }
        }
        .ignoresSafeArea()
        .buttonStyle(.bordered)
        
    }
}
#Preview(traits: PreviewTrait.landscapeLeft) {
    //#Preview {
    SelectImageView()
}
