//
//  TakeArPhotoView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct TakeArPhotoView: View {
    @EnvironmentObject var ImageData : ImageData
    var body: some View {
        Text("AR表示をして写真を撮る")
        Text("test : \(ImageData.AllImages)")
    }
}

#Preview {
    TakeArPhotoView()
}
