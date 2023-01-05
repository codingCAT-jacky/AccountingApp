//
//  HomeView.swift
//  AccountingApp
//
//  Created by pads on 2022/12/28.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var fetcher : productCRUD
    @EnvironmentObject var myAccount : loginAccount
    @Binding var identity : String
    @State var today = Date()
    @State var dateArray = [String]()
    @State private var selectedMonth = 0
    @State private var selectedYear = 4
    @State private var showCalendar = false
    @State private var showSearch = false
    @State private var showChangeProduct = false
    @State private var showAddProductView = false
    @State private var showBack = false
    @State private var pickerText = ""
    @State private var showSecondaryView = false
    @State private var showSearchView = false
    let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    return formatter
    }()
    var body: some View {
                    
        ZStack{
            NavigationView
            {
            VStack{
                HStack(spacing: 124) {
                    Button(action: {
                        showSecondaryView.toggle()
                    }){
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Menu(pickerText) {
                        Picker(selection: $selectedYear, label: Text("選擇年份"), content: {
                            ForEach(2019..<2024) { year in
                                Text("\(year)").padding()
                            }
                        })
                        .pickerStyle(.menu)
                        .onChange(of: selectedYear){ value in
                            pickerText = String(selectedYear+2019)+"-"+String(format: "%02d", selectedMonth+1)
                            print("pickerText=\(pickerText)")
                            print("String(selectedYear)=\(String(selectedYear+2019))")
                            print("String(selectedMonth)=")
                            print("\(String(format: "%02d", selectedMonth+1))")
                            fetcher.getProductByDate(date: pickerText)
                        }
                        Picker(selection: $selectedMonth, label: Text("選擇月份"), content: {
                            ForEach(1..<13) { month in
                                Text(String(format: "%02d", month)).padding()
                            }
                        })
                        .pickerStyle(.menu)
                        .onChange(of: selectedMonth){ value in
                            pickerText = String(selectedYear+2019)+"-"+String(format: "%02d", selectedMonth+1)
                            print("pickerText=\(pickerText)")
                            print("String(selectedYear)=\(String(selectedYear+2019))")
                            print("String(selectedMonth)=")
                            print("\(String(format: "%02d", selectedMonth+1))")
                            fetcher.getProductByDate(date: pickerText)
                        }
                    }
                    
                    Button{
                        showCalendar.toggle()
                    }label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .fullScreenCover(isPresented: $showCalendar, content: { calendar(showCalendar: $showCalendar)
                            .environmentObject(fetcher)
                    })
                }
                .frame(width: 500)
                .background(Color.yellow.opacity(0.5))
                if showSecondaryView {
                                    
                    VStack(spacing:30) {
                        Button(action: {
                            UserDefaults.standard.set("", forKey: "userIdentity")
                        }){
                            Text("登出")
                        }
                        .frame(width: 100, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(40)
                        Button{
                            showSearch.toggle()
                        }label: {
                            Text("搜尋")
                        }
                        .frame(width: 100, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(40)
                        .fullScreenCover(isPresented: $showSearch, content: {
                            SearchView(showSearchView: $showSearch)
                                .environmentObject(fetcher)
                            
                        })
                        ShareLink(item: Image("easyAccounting"), preview:
                                    SharePreview("share", image: Image(systemName: "square.and.arrow.up")))
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/2, minHeight: 0, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .transition(.move(edge: .leading))
                }
                HStack{
                    VStack{
                        Text("月支出")
                        Text("\(fetcher.monExpense)")
                    }
                    .frame(width: 80, height: 50)
                    .background(.yellow)
                    VStack{
                        Text("月結餘\(fetcher.monTotal)")
                            .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.cyan)
                            .clipShape(Circle())
                            .padding()
                    }
                    VStack{
                        Text("月收入")
                        Text("\(fetcher.monIncome)")
                            
                    }
                    .frame(width: 80, height: 50)
                    .background(.yellow)
                }
                
                
                    List
                    {
                        ForEach(0..<fetcher.productsDArr.count, id: \.self)
                        {
                            index in
                            if(!fetcher.productsDArr[index].isEmpty)
                            {
                                Section{
                                    ForEach(fetcher.productsDArr[index])
                                    {
                                        product1 in
                                        NavigationLink(
                                            destination: changeProduct(showChangeProduct: $showChangeProduct, inputProduct: product1).environmentObject(fetcher)
                                            ,
                                            label: {
                                                productRow(product: product1)
                                            })
                                    }
                                } header: {
                                    dateRow(product: fetcher.productsDArr[index][0])
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .onAppear{
                        let now = today.formatted(.iso8601)
                        let index = now.index(now.startIndex, offsetBy: 10)
                        let dateIn = String(now[..<index])
                        let index2 = now.index(now.startIndex, offsetBy: 7)
                        pickerText = String(now[..<index2])
                        if fetcher.products.isEmpty {
                            print("date=\(dateIn)")
                            fetcher.getProductByDate(date: dateIn)
                            print("monTotal=\(fetcher.monTotal)")
                            print("monExpense=\(fetcher.monExpense)")
                            print("monIncome=\(fetcher.monIncome)")
                        }
                    }
                    .refreshable{
                        let now = today.formatted(.iso8601)
                        let index = now.index(now.startIndex, offsetBy: 10)
                        let dateIn = String(now[..<index])
                        fetcher.getProductByDate(date: dateIn)
                    }
                
                Button{
                    showAddProductView.toggle()
                }label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                  }
                .fullScreenCover(isPresented: $showAddProductView, content: { addProductView(showAddProduct: $showAddProductView).environmentObject(fetcher)
                })
                
                  
            }
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(identity: .constant("")).environmentObject(productCRUD())
    }
}
