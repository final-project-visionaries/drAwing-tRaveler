//
//  TakePhotoView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct TakePhotoView: View {
    @State private var isCameraPresented = true

    var body: some View {
        VStack {
            Button(action: {
               isCameraPresented = true
            }) {
                Text("")
            }
//            .sheet(isPresented: $isCameraPresented) {
//                CameraView()
//            }
            .fullScreenCover(isPresented: $isCameraPresented, content: {
            CameraView()
            })
           
        }
    }
}

#Preview {
    TakePhotoView()
}
