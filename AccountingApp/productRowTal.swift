//
//  SwiftUIView.swift
//  AccountingApp
//
//  Created by pads on 2023/1/6.
//

import SwiftUI

struct productRowTal: View {
    let product:product
    var body: some View {
        VStack(spacing:0){
            Text(product.date)
                .font(.system(size: 17))
                .frame(width: 390, height: 50, alignment: .leading)
                .background(.gray)
            HStack{
                HStack(spacing:15){
                    if(product.accountingType == "expense"){
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height:35)
                            .clipped()
                        
                        
                    }
                    else if(product.accountingType == "income"){
                        Image(systemName: "cart.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width:35, height: 35)
                            .clipped()
                        
                    }
                    Text(product.category)
                    
                }
                Spacer()
                Text("$" + String(product.price))
                    .foregroundColor(.yellow)
                    .font(.system(size: 20))
                
                
            }
            .padding(.all, 5)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .border(.black, width: 2)
        }
    }
}

struct productRowTal_Previews: PreviewProvider {
    static var previews: some View {
        productRowTal(product: .demoproduct)
    }
}
