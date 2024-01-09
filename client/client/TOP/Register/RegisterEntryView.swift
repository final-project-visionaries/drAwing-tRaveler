//
//  SwiftUIView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct RegisterEntryView: View {
    var body: some View {
        NavigationLink(destination: RegisterMainView()){
            Text("新規登録する")
        }
    }
}

//#Preview {
//    RegisterEntryView()
//}
