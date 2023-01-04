//
//  SwiftUIView.swift
//  AccountingApp
//
//  Created by pads on 2022/12/6.
//

import SwiftUI

struct productRow: View {
    let product : product
    var body: some View {
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

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        productRow(product: product.demoproduct)
    }
}
