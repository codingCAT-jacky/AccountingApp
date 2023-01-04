import SwiftUI

struct SignInView: View {
    @EnvironmentObject var fetcher : productCRUD
    @EnvironmentObject var myAccount : loginAccount
    @State var email : String = ""
    @State var password : String = ""
    @State var showAlert : Bool =  false
    @State var showHomePage : Bool = false
    @State var showSignUpPage : Bool = false
    @State var identity1 : String = ""
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    Image("easyAccounting")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height:200)
                        .overlay(
                            Text("記帳助手")
                                .foregroundColor(Color.black)
                                .offset(x:55,y:85))
                    Text("登入")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .frame(height: 100, alignment: .center)
                        .offset(x:0,y:30)
                }.offset(x:0,y:-60)
                
                TextField("帳號/電子郵件",text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 300, height: 50, alignment: .center)
                    .offset(x:0,y:-20)
                    
                SecureField("密碼",text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 300, height: 100, alignment: .center)
                    .offset(x:0,y:-40)
                    
                
                Button(action: {
                    let url = URL(string: "https://favqs.com/api/session")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Token token=\"4458804dfe95374694e4752ab9dadba8\"", forHTTPHeaderField: "Authorization")
                    let encoder = JSONEncoder()
                    let user = SessionUser( user : SessionBody(login: email, password: password) )
                    let data = try? encoder.encode(user)
                    request.httpBody = data
                    print("user=\(user)")
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data {
                            do{
                                let content = String(data: data, encoding: .utf8)
                                print("content=\(content ?? "responseContent")")
                                
                                let SResponse = try JSONDecoder().decode(SessionResponse.self, from: data)
                                print("SResponse=\(SResponse)")
                                
                                DispatchQueue.main.async {
                                    myAccount.user_token = SResponse.user_token
                                    UserDefaults.standard.set(SResponse.user_token, forKey: "userIdentity")
                                    if(SResponse.user_token != "")
                                    {
                                        identity1 = SResponse.user_token
                                        showHomePage = true
                                    }
                                }
                                
                            }catch{
                                print(error)
                                showAlert = true
                            }
                        }
                        else if error != nil {
                            showAlert = true
                        }
                    }.resume()
                }, label: {
                    Text("登入")
                }).alert(isPresented: $showAlert, content: {
                    Alert(title: Text("帳號或密碼錯誤"))
                })
                .fullScreenCover(isPresented: $showHomePage, content: {
                    HomeView(identity: $identity1).environmentObject(fetcher)
                        .environmentObject(myAccount)
                })
                
                .frame(width: 100, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(40)
                .padding()
                .offset(y:-10)
                
                Button{
                    showSignUpPage = true
                }label: {
                    Text("註冊")
                }
                .fullScreenCover(isPresented: $showSignUpPage, content: {
                    SignUpView(showSignUpPage: $showSignUpPage)
                })
                .offset(x: 120, y: -150)
                
            }
            
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.cyan.opacity(0.5))
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(productCRUD())
                    .environmentObject(loginAccount())
        
    }
}
