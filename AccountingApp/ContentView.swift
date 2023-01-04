//
//  ContentView.swift
//  AccountingApp
//
//  Created by pads on 2022/12/4.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var fetcher = productCRUD()
    @StateObject private var myAccount = loginAccount()
    @AppStorage("userIdentity") var userIdentity : String = ""
    var body: some View {
        
        if(userIdentity == "")
        {
            SignInView().environmentObject(fetcher)
                        .environmentObject(myAccount)
        }
        else
        {
            HomeView(identity: $userIdentity).environmentObject(fetcher)
                              .environmentObject(myAccount)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

