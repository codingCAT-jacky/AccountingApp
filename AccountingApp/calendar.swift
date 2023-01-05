//
//  calendar.swift
//  AccountingApp
//
//  Created by pads on 2022/12/28.
//

import SwiftUI

struct calendar: View {
    @State private var choseTime = Date()
    @State private var choseTimeString = ""
    @State private var showChangeProduct = false
    @Binding var showCalendar : Bool
    @EnvironmentObject var fetcher : productCRUD
    let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    return formatter
    }()
    var body: some View {
        VStack{
            
            HStack(spacing:93){
                Button{
                    showCalendar.toggle()
                }label: {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                }
                Menu(dateFormatter.string(from: choseTime)) {
                    
                }
                
                
                Button{
                    showCalendar.toggle()
                }label: {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                
            }
            .frame(width: 500)
            .background(Color.yellow.opacity(0.5))
            
            DatePicker("查詢時間", selection: $choseTime, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: choseTime){ value in
                    let inputDate = dateFormatter.string(from: choseTime)
                    fetcher.getProductByOneDate(date: inputDate)
                }
            HStack(spacing:45){
                HStack{
                    Image(systemName: "dollarsign.circle")
                    Text("支出\(fetcher.datExpense)")
                }
                HStack{
                    Image(systemName: "bookmark.fill")
                    Text("結餘\(fetcher.datTotal)")
                }
                HStack{
                    Image(systemName: "cart.circle")
                    Text("收入\(fetcher.datIncome)")
                }
            }
            List
            {
                ForEach(fetcher.products, id: \.self.id)
                {
                    product1 in
                    NavigationLink(
                    destination:
                        changeProduct(showChangeProduct:$showChangeProduct, inputProduct: product1).environmentObject(fetcher)
                                    ,
                        label: {
                            productRow(product: product1)
                        })
                }
            }
            .listStyle(.plain)
            .onAppear{
                let inputDate = dateFormatter.string(from: choseTime)
                    print("date=\(inputDate)")
                    fetcher.getProductByOneDate(date: inputDate)
            }
        }
        
        
    }
}

struct calendar_Previews: PreviewProvider {
    static var previews: some View {
        calendar(showCalendar: .constant(true)).environmentObject(productCRUD())
    }
}
