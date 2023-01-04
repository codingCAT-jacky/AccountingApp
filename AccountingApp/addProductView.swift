//
//  addProductView.swift
//  AccountingApp
//
//  Created by pads on 2022/12/28.
//

import SwiftUI

struct addProductView: View {
    @State private var acdate = Date()
    @State private var selectedCate = ""
    @State private var price = ""
    @State private var description = ""
    @EnvironmentObject var fetcher : productCRUD
    let categoryIcon = [
    "bag", "creditcard", "dollarsign.circle" , "giftcard.fill", "banknote", "banknote.fill", "yensign.circle", "creditcard.and.123", "cart.fill", "bag.fill.badge.plus", "bag.cirle.fill", "giftcard"
    ]
    let columns = Array(repeating: GridItem(), count: 4)
    var body: some View {
        VStack{
            LazyVGrid(columns: columns)
            {
                ForEach(categoryIcon.indices, id: \.self)
                {
                    item in
                    iconView(icon: categoryIcon[item], name: item)
                    
                }
            }
            .offset(x: 0, y: -190)
            DatePicker("新增記帳時間", selection:  $acdate, displayedComponents: .date)
            HStack{
                Label("記帳類型", systemImage: "lock.open.fill")
                Picker(selection: $selectedCate, label: Text("記帳類型"), content: {
                    ForEach(1..<13) { month in
                        Text("\(month)")
                    }
                })
                .pickerStyle(.menu)
            }
            TextField("金額",text:$price).textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .frame(width: 300, height: 50, alignment: .center)
                .offset(x:0,y:-5)
            TextField("備註",text: $description).textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .frame(width: 300, height: 50, alignment: .center)
                .offset(x:0,y:-30)
            Button(action: {
                let url = URL(string: "http://localhost:8080/products")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let encoder = JSONEncoder()
//                let newProduct = product(date: String(acdate), category: selectedCate, price: Int(price), accountingType: "expense", description: description)
//                let data = try? encoder.encode(newProduct)
//                request.httpBody = data
//                print("newProduct=\(newProduct)")
                
            }, label: {
                Text("登入")
            })
            .frame(width: 100, height: 50, alignment: .center)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(40)
            .padding()
            .offset(y:-10)
        }
        
    }
}

struct addProductView_Previews: PreviewProvider {
    static var previews: some View {
        addProductView()
    }
}

struct iconView: View{
    let icon: String
    let name: Int
    var body: some View{
        VStack{
                Image(systemName: icon)
                Text(String(name))
        }
    }
}
