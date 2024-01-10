import SwiftUI

struct RegisterMainView: View {
    @State private var username  = ""
    @State private var password  = ""
    @State private var password2 = ""
    @State private var isSignUp  = false
    @State private var showingAlert = false
    @State private var showingAlertMsg = ""
    @State private var isValidUsername  = false
    @State private var isValidPassword  = false
    @State private var isValidPassword2 = false
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.white, .cyan]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 15){
                Image(systemName: "sun.max.fill").foregroundColor(.red).onTapGesture{isSignUp = true}//ショートカット
                Text("ユーザー名とパスワードを入力してください").bold().foregroundStyle(.black)
                TextField("ユーザー名",text: $username)
                    .frame(width: 300).padding(10).background(Color(UIColor.systemGray4))
                    .cornerRadius(20).shadow(color: .gray, radius: 10)
                    .onChange(of: username) {
                        isValidUsername = username.isAlphanumeric && !username.isEmpty ? true : false
                    }
                SecureField("パスワード",text: $password)
                    .frame(width: 300).padding(10).background(Color(UIColor.systemGray4))
                    .cornerRadius(20).shadow(color: .gray, radius: 10)
                    .onChange(of: password) {
                        isValidPassword = password.isAlphanumeric && !password.isEmpty ? true : false
                    }
                SecureField("確認用パスワード",text: $password2)
                    .frame(width: 300).padding(10).background(Color(UIColor.systemGray4))
                    .cornerRadius(20).shadow(color: .gray, radius: 10)
                    .onChange(of: password2) {
                        isValidPassword2 = password2.isAlphanumeric && !password2.isEmpty ? true : false
                    }
                Button(action: {() in
                    Task {
                        if password == password2 {
                            let sendData = ["username":self.username, "password":self.password]
                            print("sendData : \(sendData)")
                            let result = await apiSignUpPostRequest(reqBody: sendData)
                            print("result : \(result.message)")
                            if result.message == "新規登録完了" {
                                PlaySound.instance.playSound(filename: "top")
                                isSignUp = true
                            } else {
                                showingAlert = true
                                showingAlertMsg = "すでに存在しているユーザー名です"
                            }
                        } else {
                            showingAlert = true
                            showingAlertMsg = "パスワードと確認用パスワードが一致しません"
                        }
                    }
                }){Text("新規登録")}
                    .frame(width: 200, height: 45)
                    .foregroundColor(Color.white).bold()
                    .background(isValidUsername && isValidPassword && isValidPassword2 ? Color.blue : Color.gray)
                    .cornerRadius(10, antialiased: true)
                    .disabled(!isValidUsername || !isValidPassword || !isValidPassword2)
            }
        }
        .customBackButton()
        .navigationDestination(isPresented: $isSignUp){ HomeView() }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("エラー"), message: Text(showingAlertMsg), dismissButton: .default(Text("OK")))
        }
    }
}

//#Preview {
//    RegisterMainView()
//}
