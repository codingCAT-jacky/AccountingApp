

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var fetcher : productCRUD
    @State private var searchText = ""
    @Binding var showSearchView : Bool
    var searchResult: [product]{
        if searchText.isEmpty{
            return fetcher.products
        }
        else{
            return fetcher.products.filter{ product1 in
                product1.category.contains(searchText)
            }
        }
    }
    var body: some View {
        VStack{
            HStack(spacing:93){
                Button{
                    showSearchView.toggle()
                }label: {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                }
                Text("記帳助手搜尋：")
                Button{
                    showSearchView.toggle()
                }label: {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
            }
            .frame(width: 500)
            .background(Color.yellow.opacity(0.5))
            .onAppear{
                fetcher.products.removeAll()
                fetcher.getAllProduct()
            }
            
            
            NavigationView{
                List
                {
                    ForEach(searchResult){  product1 in
                        productRowTal(product: product1)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText)
                .refreshable{
                    fetcher.getProductByCategory(category: searchText)
                }
                
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(showSearchView: .constant(true)).environmentObject(productCRUD())
    }
}
