//
//  RegisterMainView.swift
//  client
//
//  Created by user on 2023/12/20.
//

import SwiftUI

struct RegisterMainView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSingUp = false
    @State private var showingAlert=false
    @State private var confirmPassAlert = false
    @State private var showingAlerMsg = ""

       var body: some View {
           TextField("ユーザー名",text: $username).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
           SecureField("パスワード",text: $password).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
           SecureField("確認用パスワード",text: $confirmPassword).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

           Button(action: {() in
               Task {
                   if password == confirmPassword {
                       let sendData = ["username":self.username,
                                       "password":self.password]
                       print("sendData : \(sendData)")
                       let result = await apiSignUpPostRequest(reqBody: sendData)
                       print("result : \(result.message)")
                       if result.message == "新規登録完了" {
                           isSingUp = true
                       } else {
                           showingAlert = true
                           showingAlerMsg = "すでに存在しているユーザー名です"
                           
                       }
                   } else {
                       showingAlert = true
                       showingAlerMsg = "パスワードと確認用パスワードが一致しません"
                   }
                   
               }
               
           }){
               Text("新規登録")
           }
           NavigationLink(destination:HomeView(), isActive: $isSingUp) {
                       EmptyView()
           }.alert(isPresented: $showingAlert) {
               
               Alert(title: Text("エラー"), message: Text(showingAlerMsg), dismissButton: .default(Text("OK")))
           }
           }
}

//#Preview {
//    RegisterMainView()
//}
