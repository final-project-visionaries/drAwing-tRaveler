//
//  TakeArPhotoView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct TakeArPhotoView: View {
    @EnvironmentObject var imageData : ImageData
    var body: some View {
        Text("AR表示をして写真を撮る")
        Text("test : \(imageData.SelectedImages)")
    }
}

#Preview {
    TakeArPhotoView().environmentObject(ImageData())
}
