//
//  HomeView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("ホーム画面")
        VStack {
                List {
                    NavigationLink(destination: DrawingView()){
                            Image(systemName: "house.fill")
                                .imageScale(.large)
                            Text("絵を描く")
                            
                        }
                    NavigationLink(destination: AlbumView()){
                        //.environmentObject(UserData())) {
                            Image(systemName: "macpro.gen3.fill")
                                .imageScale(.large)
                            Text("アルバム")


                        }

                    NavigationLink(destination: TakePhotoView()){
                            Image(systemName: "house.fill")
                                .imageScale(.large)
                            Text("絵の写真を撮る")

                        }
                    NavigationLink(destination: SelectImageView()){
                            Image(systemName: "house.fill")
                                .imageScale(.large)
                            Text("絵を選ぶ")

                        }
                }
        }
    }
}

#Preview {
    HomeView()
}
