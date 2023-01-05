//
//  addProductView.swift
//  AccountingApp
//
//  Created by pads on 2022/12/28.
//

import SwiftUI

struct addProductView: View {
    @Binding var showAddProduct : Bool
    @State private var acdate = Date()
    @State private var selectedCate = 0
    @State private var selectedType = 0
    @State private var selectedDat = ""
    @State private var price = ""
    @State private var description = ""
    @State private var currentCate = "包包"
    @State private var currentIcon = "bag"
    @State private var showAlert = false
    @State private var showAlertTop = false
    @State private var returError = false
    @State private var returCorrect = false
    @EnvironmentObject var fetcher : productCRUD
    let accountingRole = ["expense", "income"]
    let accountingRoleText = ["支出", "收入"]
    let categoryIcon = [
    "bag", "creditcard" , "giftcard.fill", "banknote", "shuffle.circle", "play.rectangle.fill", "yensign.circle", "pencil.tip.crop.circle.badge.plus", "cart.fill", "moon.stars", "tray.full", "books.vertical.circle"
    ]
    let cateName = ["包包", "卡債", "禮物", "貸款", "串流", "yt會員", "舶來品"
                        , "文具", "日用品", "夜娛樂", "食物", "書籍"]
    let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    return formatter
    }()
    let columns = Array(repeating: GridItem(), count: 4)
    @State var selectedOption: String = "expense"
    var body: some View {
        VStack{
            HStack(spacing:90){
                Button{
                    showAddProduct.toggle()
                }label: {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                }
                VStack{
                    Text("記帳類型")
                        .font(.system(size: 22))
                        .offset(y:10)
                    Picker(selection: $selectedType){
                        Text(accountingRoleText[0]).tag(0)
                        Text(accountingRoleText[1]).tag(1)
                    } label: {
                        Text("記帳類型")
                    }
                }
                Button{
                    showAddProduct.toggle()
                }label: {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                }
               
                
            }
            .frame(width: 500)
            .background(Color.yellow.opacity(0.5))
            .offset(y:-65)
                LazyVGrid(columns: columns)
                {
                    ForEach(categoryIcon.indices, id: \.self)
                    {
                        item in
                        Button{
                             currentCate = cateName[item]
                             currentIcon = categoryIcon[item]
                        }label: {
                            VStack{
                                Image(systemName: categoryIcon[item])
                                    .frame(height:40)
                                Text(cateName[item])
                            }
                        }
                        .onChange(of: currentCate)
                        {
                            value in
                            print("currentCate=\(currentCate)")
                        }
                    }
                    
                }
                .onAppear{
                    let now = acdate.formatted(.iso8601)
                    let index = now.index(now.startIndex, offsetBy: 10)
                    let dateIn = String(now[..<index])
                    selectedDat = dateIn
                }
                .offset(x: 0, y: -40)
            VStack(spacing: 30){
                DatePicker("新增記帳時間", selection:  $acdate, displayedComponents: .date)
                    .frame(width: 300 )
                    .onChange(of: acdate){ value in
                        selectedDat = dateFormatter.string(from: value)
                    }
                HStack(spacing:130){
                    Text("記帳種類")
                    
                    VStack{
                        Image(systemName: currentIcon)
                        Text(currentCate)
                    }
                }
                TextField("金額",text:$price).textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 300, height: 50, alignment: .center)
                    .offset(x:0,y:-5)
                TextField("備註",text: $description).textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: 300, height: 50, alignment: .center)
                    .offset(x:0,y:-30)
            }
            
            Button(action: {
                let url = URL(string: "http://localhost:8080/products")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let encoder = JSONEncoder()
               
                let newProduct = productCreate(date: selectedDat, category: currentCate, price: Int(price) ?? 0, accountingType: accountingRole[selectedType], description: description )
                let data = try? encoder.encode(newProduct)
                request.httpBody = data
                
                print("newProduct=\(newProduct)")
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if data != nil {
                        do{
                            print("data data data data data")
                            print("\(data)")
                            let content = String(data: data!, encoding: .utf8)
                            print("content=\(content)")
                            if((content!.contains("timestamp")) == true)
                            {
                                returError = true
                            }
                            else
                            {
                                returCorrect = true
                            }
                        }
                    }
                    else if error != nil {
                        print("error=\(error)")
                    }
                }.resume()
                
            }, label: {
                Text("新增")
            })
            
            .frame(width: 100, height: 50, alignment: .center)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(40)
            .padding()
            .offset(y:-10)
            
            if(returError)
            {
                Text("輸入訊息有誤，新增失敗")
            }
            else if(returCorrect)
            {
                Text("新增成功")
            }
        }

    }
}

struct addProductView_Previews: PreviewProvider {
    static var previews: some View {
        addProductView(showAddProduct: .constant(true) ).environmentObject(productCRUD())
    }
}

