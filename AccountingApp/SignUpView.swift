//
//  SignUpView.swift
//  AccountingApp
//
//  Created by pads on 2022/12/27.
//

import SwiftUI

struct SignUpView: View {
    @State var login : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var confirmPassword : String = ""
    @State private var showAlert = false
    @State private var alertType = false
    @State private var alertType1 = false
    @State private var alertType2 = false
    @Binding var showSignUpPage : Bool
    var body: some View {
            VStack{
                    Image("easyAccounting")
                        .resizable()
                        .frame(width: 440, height: 330)
                        .offset(x: 0, y:30)
                Text("註冊")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .frame(height: 100, alignment: .center)
                    .offset(y:50)
                VStack(spacing:10)
                {
                    TextField("使用者名稱",text: $login).textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(width: 300, height: 50, alignment: .center)
                        
                    TextField("電子郵件",text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(width: 300, height: 50, alignment: .center)
                       
                    SecureField("密碼",text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(width: 300, height: 50, alignment: .center)
                        
                    SecureField("確認密碼",text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(width: 300, height: 50, alignment: .center)
                        
                }.offset(x: 0, y: 50)
                
                
                Button(action: {
                    if(password == confirmPassword)
                    {
                        let url = URL(string: "https://favqs.com/api/users")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.setValue("Token token=\"4458804dfe95374694e4752ab9dadba8\"", forHTTPHeaderField: "Authorization")
                        let encoder = JSONEncoder()
                        let user = NewUser(user: NewUserBody(login: login, email:email, password: password))
                        let data = try? encoder.encode(user)
                        request.httpBody = data
                        print("user=\(user)")
                        
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            if let data {
                                do{
                                    let content = String(data: data, encoding: .utf8)
                                    print("content=\(content ?? "NewUserResponse nothing")")
                                    let UserResponse = try JSONDecoder().decode(NewUserResponse.self, from: data)
                                    print(UserResponse)
                                    if(UserResponse.user_token != "")
                                    {
                                        showSignUpPage = false
                                    }
                                }catch{
                                    print(error)
                                    alertType1 = true
                                    showAlert = true
                                }
                            }
                            else if error != nil {
                                alertType1 = true
                                showAlert = true
                                
                            }
                        }.resume()
                    }
                    else
                    {
                        password = ""
                        confirmPassword = ""
                        alertType.toggle()
                        showAlert = true
                    }
                        
                }
                , label: {
                    Text("確認")
                })
                .alert(isPresented: $showAlert, content: {
                    if(alertType1){
                      return Alert(title: Text("網路連接失敗"))
                    }
                    else{
                      return Alert(title: Text("密碼與確認密碼不符！"))
                    }
                })
                .frame(width: 100, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(40)
                .padding()
                .offset(y:80)
            }.offset(y: -150.0)
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showSignUpPage: .constant(true))
    }
}
