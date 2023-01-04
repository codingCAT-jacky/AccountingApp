//
//  dateRow.swift
//  AccountingApp
//
//  Created by pads on 2022/12/28.
//

import SwiftUI

struct dateRow: View {
    let product : product
    let totalPrice = 0
    var body: some View {
        Text(product.date)
            .font(.system(size: 17))
            .frame(width: 355, height: 50, alignment: .leading)
            .background(.gray)
            
    }
}

struct dateRow_Previews: PreviewProvider {
    static var previews: some View {
        dateRow(product: .demoproduct)
    }
}
