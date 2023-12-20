//
//  SelectImageView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct SelectImageView: View {
    var body: some View {
        Text("絵を選択")
        VStack {
                List {
                    NavigationLink(destination:TakeArPhotoView()){
                            Image(systemName: "house.fill")
                                .imageScale(.large)
                            Text("AR写真を撮る")
                            
                        }
                }
        }
    }
}

#Preview {
    SelectImageView()
}
