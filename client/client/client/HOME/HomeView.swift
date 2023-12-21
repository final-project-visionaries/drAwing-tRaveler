//
//  HomeView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var imageData : ImageData
    @State private var isCameraPresented = false
    var body: some View {
        //Text("ホーム画面")
        //Text(imageData.dummyData[0]["image_name"] ?? "Hello")
        ZStack{
            Image("sky").edgesIgnoringSafeArea(.all)
            VStack{
                HStack (spacing : 200) {
                    NavigationLink(destination: DrawingView()){
                        VStack{
                            Image("drawing")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                )
                            Text("おえかきする").foregroundColor(.black)
                        }
                        
                    }
                    NavigationLink(destination: AlbumView()){
                        VStack{
                            Image("album")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                )
                            Text("あるばむをみる").foregroundColor(.black)
                        }
                        
                        
                    }
                }
                HStack (spacing : 200){
                    Button(action: {
                        isCameraPresented = true
                    }) {
                        HStack{
                            VStack{
                                Image("takephoto")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(75)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                    )
                                Text("えのしゃしんをとる")
                                    .foregroundColor(.black)
                            }
                            //Spacer()
                        }
                        
                    }
                    .fullScreenCover(isPresented: $isCameraPresented, content: {
                        //CameraView()
                        TakePhotoView()
                    })
                    NavigationLink(destination: SelectImageView().environmentObject(client.ImageData())){
                        VStack{
                            Image("takearphoto")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75).stroke(Color.white, lineWidth: 1)
                                )
                            Text("けしきとしゃしんをとる").foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}

#Preview(traits: PreviewTrait.landscapeLeft){
    HomeView().environmentObject(ImageData())
}
