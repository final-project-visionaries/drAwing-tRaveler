
import SwiftUI

struct SelectImageView: View {
    @EnvironmentObject var ImageData : ImageData
    @State private var activie = false
//    @State selectID = []
//    arr = ["pic1", "pic2", "pic3"]
    
    var body: some View {
        
        ZStack{
            Image("sky").edgesIgnoringSafeArea(.all)
            ScrollView(.horizontal, showsIndicators: false)  {
                HStack(spacing:100){
                    NavigationLink(destination: TakeArPhotoView().environmentObject(client.ImageData())){
                        Image(systemName: "house.fill")
                            .imageScale(.large)
//                        Text("ARを表示")
                        Text("test : \(ImageData.AllImages)")
                    }
//                    ForEach(arr)...
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
