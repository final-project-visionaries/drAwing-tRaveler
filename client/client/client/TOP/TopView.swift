//
//  ContentView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct TopView: View {
    var body: some View {
        
        VStack {
            NavigationView {
                List {
                    Text("TOP")//ここで仮置き（TOP画面だとわかるように。）
                    NavigationLink(destination: HomeView().environmentObject(ImageData())){
                            Image(systemName: "house.fill")
                                .imageScale(.large)
                            Text("ホーム")
                            
                        }
//                    NavigationLink(destination: LoginEntryView()){
//                        //.environmentObject(UserData())) {
//                            Image(systemName: "macpro.gen3.fill")
//                                .imageScale(.large)
//                            Text("ログイン")
//                            
//                            
//                        }
//                    
//                    NavigationLink(destination: RegisterEntryView()){
//                            Image(systemName: "house.fill")
//                                .imageScale(.large)
//                            Text("新規登録")
//                            
//                        }
                }
            }
            
        }
    }
}

#Preview {
    TopView()
}
