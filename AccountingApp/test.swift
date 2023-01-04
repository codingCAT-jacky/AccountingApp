//
//  test.swift
//  AccountingApp
//
//  Created by pads on 2023/1/4.
//

import SwiftUI

struct test: View {
    @State private var showSecondaryView = false
    @State private var showSearchView = false
    var body: some View {
        ZStack {
            // 主要視圖
            VStack {
                Button("Show secondary view") {
                    self.showSecondaryView = true
                }
                Spacer()
            }
            .padding()

            // 附加視圖
            if showSecondaryView {
                
                VStack(spacing:70) {
                    
                        Button(action: {
                            self.showSecondaryView = false
                        }){
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 100, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(40)
                    Button(action: {
                        UserDefaults.standard.set("", forKey: "userIdentity")
                    }){
                        Text("登出")
                    }
                    .frame(width: 100, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                    Button(action: {
                        self.showSearchView = true
                    }){
                        Text("搜尋")
                    }
                    .fullScreenCover(isPresented: $showSearchView, content: { SearchView()
                    })
                    .frame(width: 100, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                    Spacer()
                }
                .padding()
                .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/2, minHeight: 0, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .transition(.move(edge: .leading))
            }
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
