//
//  LoginView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct LoginEntryView: View {
    var body: some View {
        NavigationLink(destination: LoginMainView()){
            Text("ログインする")
        }
    }
}

//#Preview {
//    LoginEntryView()
//}
