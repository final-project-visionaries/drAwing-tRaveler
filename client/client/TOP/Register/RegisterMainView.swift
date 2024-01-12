import SwiftUI

struct RegisterMainView: View {
    @State private var username  = ""
    @State private var password  = ""
    @State private var password2 = ""
    @State private var isSignUp  = false
    @State private var isHomeView = false
    @State private var showingAlert = false
    @State private var showingAlertMsg = ""
    @State private var isValidUsername  = false
    @State private var isValidPassword  = false
    @State private var isValidPassword2 = false
    @State private var showingComplete = false
    
    var body: some View {
        
        ZStack{
            Image("sky3").resizable()
                .scaledToFit()
                .frame(width: 1400, height: 600)
                .clipShape(Rectangle())
            
            VStack(spacing: 15){
                Image("phone2momdad").resizable().frame(width: 600, height: 60).aspectRatio(contentMode: .fit)
                    .background(Color.white.opacity(0.5), in: RoundedRectangle(cornerRadius: 15))
                HStack{
                    Text("ユーザー名とパスワードを入力してください").bold().foregroundStyle(.black)
                    Image(systemName: "sun.max.fill").foregroundColor(.red).onTapGesture{isHomeView = true}//ショートカット
                }
                TextField("ユーザー名",text: $username)
                    .frame(width: 300).padding(10).background(Color.white)
                    .cornerRadius(10)//.shadow(color: .black, radius: 10)
                    .onChange(of: username) {
                        isValidUsername = username.isAlphanumeric && !username.isEmpty ? true : false
                    }
                SecureField("パスワード",text: $password)
                    .frame(width: 300).padding(10).background(Color.white)
                    .cornerRadius(10)//.shadow(color: .gray, radius: 10, x: 0, y: 10)
                    .onChange(of: password) {
                        isValidPassword = password.isAlphanumeric && !password.isEmpty ? true : false
                    }
                SecureField("確認用パスワード",text: $password2)
                    .frame(width: 300).padding(10).background(Color.white)
                    .cornerRadius(10)//.shadow(color: .gray, radius: 10, x: 10, y: 0)
                    .onChange(of: password2) {
                        isValidPassword2 = password2.isAlphanumeric && !password2.isEmpty ? true : false
                    }
                Button(action: {() in
                    Task {
                        if password == password2 {
                            let sendData = ["username":self.username, "password":self.password]
                            print("sendData : \(sendData)")
                            showingComplete.toggle()
                            let result = await apiSignUpPostRequest(reqBody: sendData)
                            print("result : \(result.message)")
                            if result.message == "新規登録完了" {
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
            
            if showingComplete == true{
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(.black).opacity(0.5)
                    .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
                if isSignUp == false{
                    ProgressView().tint(.white).controlSize(.large)
                } else {
                    VStack{
                        Text("新規登録が完了しました.").foregroundStyle(.white)
                        Button(action: {() in
                            PlaySound.instance.playSound(filename: "top")
                            isHomeView.toggle()
                        }){Text("OK")}
                            .frame(width: 100, height: 45)
                            .foregroundColor(Color.white).bold()
                            .background(Color.blue)
                            .cornerRadius(10, antialiased: true)
                    }
                }
            }
        }
        .onAppear{
            username = ""
            password = ""
            password2 = ""
        }
        .customBackButton()
        .navigationDestination(isPresented: $isHomeView){ HomeView() }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("エラー"), message: Text(showingAlertMsg), dismissButton: .default(Text("OK")))
        }
    }
}
