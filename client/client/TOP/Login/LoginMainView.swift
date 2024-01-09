//
//  LoginMainView.swift
//  client
//
//  Created by user on 2023/12/20.
//

//import SwiftUI
//
struct LoginMainView_: View {
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

import SwiftUI

struct LoginMainView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showingAlert = false
    @State private var isValidUsername = false
    @State private var isValidPassword = false
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 15){
                Text("ユーザー名とパスワードを入力してください").bold().foregroundStyle(.black)
                TextField("ユーザー名", text: $username)
                    .frame(width: 300).padding(10).background(Color(UIColor.systemGray4))
                    .cornerRadius(20).shadow(color: .gray, radius: 10)
                    .onChange(of: username) {
                        isValidUsername = username.isAlphanumeric && !username.isEmpty ? true : false
                        // isAlphanumeric(最下部で定義)かつ空でなければログインボタンが押せるようになる
                    }
                SecureField("パスワード", text: $password)
                    .frame(width: 300).padding(10).background(Color(UIColor.systemGray4))
                    .cornerRadius(20).shadow(color: .gray, radius: 10)
                    .onChange(of: password) {
                        isValidPassword = password.isAlphanumeric && !password.isEmpty ? true : false
                        // isAlphanumeric(最下部で定義)かつ空でなければログインボタンが押せるようになる
                    }
                
                Button(action: {
                    Task {
                        let sendData = ["username": self.username, "password": self.password]
                        print("sendData : \(sendData)")
                        let result = await apiAuthPostRequest(reqBody: sendData)
                        print("result : \(result.message)")
                        if result.message == "ログイン成功" {
                            PlaySound.instance.playSound(filename: "top")
                            isLoggedIn = true
                        } else {
                            showingAlert = true
                        }
                    }
                }){Text("ログイン")}
                    .frame(width: 200, height: 45)
                    .foregroundColor(Color.white).bold()
                    .background(isValidUsername && isValidPassword ? Color.blue : Color.gray)
                    .cornerRadius(10, antialiased: true)
                    .disabled(!isValidUsername || !isValidPassword)
                
            }
            .customBackButton()
            .navigationDestination(isPresented: $isLoggedIn){ HomeView() }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("エラー"), message: Text("ユーザー名またはパスワードが間違ってます"), dismissButton: .default(Text("OK")))
            }
        } // ZStack
    }
}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
