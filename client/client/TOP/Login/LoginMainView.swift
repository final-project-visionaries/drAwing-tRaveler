//
//  LoginMainView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct LoginMainView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showingAlert=false

    var body: some View {
        TextField("ユーザー名",text: $username).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        SecureField("パスワード",text: $password).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        Button(action: {() in
            Task {
                let sendData = ["username":self.username,
                                "password":self.password]
                print("sendData : \(sendData)")
                let result = await apiAuthPostRequest(reqBody: sendData)
                print("result : \(result.message)")
                if result.message == "ログイン成功" {
                    isLoggedIn = true
                } else {
                    showingAlert = true
                }
            }
            
        }){
            Text("ログイン")
        }
        NavigationLink(destination:HomeView(), isActive: $isLoggedIn) {
                    EmptyView()
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("エラー"), message: Text("ユーザー名またはパスワードが間違ってます"), dismissButton: .default(Text("OK")))
        }
        }
}

//#Preview {
//    LoginMainView()
//}
