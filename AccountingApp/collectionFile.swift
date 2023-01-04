//
//  collectionFile.swift
//  AccountingApp
//
//  Created by pads on 2022/12/5.
//

import Foundation

struct SearchResponse: Codable{
    let results: [product]
}

struct product: Codable, Identifiable{
    let id:String?
    let date:String
    let category:String
    let price:Int
    let accountingType:String
    let description:String?
}
extension product{
    static let demoproduct = product(id: "demoproduct", date: "2022-12-06", category: "測試", price: 10, accountingType: "income", description: "nothing")
}


class productCRUD : ObservableObject{
    @Published var products = [product]()
    @Published var productsDArr = [[product]]()
    @Published var showError = false
    @Published var monTotal : Int = 0
    @Published var monIncome : Int = 0
    @Published var monExpense : Int = 0
    @Published var datTotal : Int = 0
    @Published var datIncome : Int = 0
    @Published var datExpense : Int = 0
    var error: Error? {
            willSet {
                DispatchQueue.main.async {
                    self.showError = newValue != nil
                }
            }
        }

    enum FetchError: Error {
        case invalidURL
    }
    
    func getProductByDate(date:String)
    {
        let urlString = "http://localhost:8080/monthTotal?date=\(date)"
        print(urlString)
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
                  error = FetchError.invalidURL
                  return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do{
                    let SearchResponse = try JSONDecoder().decode([product].self, from: data)
                    DispatchQueue.main.async {
                        self.productsDArr.removeAll()
                        self.products.removeAll()
                        self.products = SearchResponse
                        self.error = nil
                        var dateArr = [String]()
                        var productInDate = [product]()
                        var index = 0
                        self.monIncome = 0
                        self.monExpense = 0
                        self.monTotal = 0
                        for item in self.products{
                            if(item.accountingType == "income")
                            {
                                self.monTotal = item.price + self.monTotal
                                self.monIncome = item.price + self.monIncome
                            }
                            else
                            {
                                self.monTotal = self.monTotal - item.price
                                self.monExpense = self.monExpense - item.price
                            }
                            print("monTotal=\(self.monTotal)")
                            print("monExpense=\(self.monExpense)")
                            print("monIncome=\(self.monIncome)")
                            if(dateArr.contains(item.date))
                            {
                                productInDate.append(item)
                            }
                            else
                            {
                                if(index != 0)
                                {
                                    self.productsDArr.append(productInDate)
                                }
                                index += 1
                                dateArr.append(item.date)
                                productInDate.removeAll()
                                productInDate.append(item)
                            }
                            print("productInDate=\(productInDate[0].date)")
                        }
                        self.productsDArr.append(productInDate)
                        print("by date: products=")
                        for index in 0..<self.productsDArr.count
                        {
                            print("index=\(index)")
                            print(self.productsDArr[index])
                        }
                    }
                }
                catch{
                    self.error = error
                    print("error1=")
                    print(error)
                }
            }
            else if let error{
                self.error = error
                print("error2=")
                print(error)
            }
        }.resume()
    }
    func getProductByCategory(category:String)
    {
        let urlString = "http://localhost:8080/products/category?category=\(category)"
        print(urlString)
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
                  error = FetchError.invalidURL
                  return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do{
                    let SearchResponse = try JSONDecoder().decode([product].self, from: data)
                    DispatchQueue.main.async {
                        self.products = SearchResponse
                        self.error = nil
                        print("by category: products=")
                        print(self.products)
                    }
                }
                catch{
                    self.error = error
                }
            }
            else if let error{
                self.error = error
            }
        }.resume()
    }
    func getProductByDescription(Description:String)
    {
        let urlString = "http://localhost:8080/products/description?description=\(Description)"
        print(urlString)
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
                  error = FetchError.invalidURL
                  return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do{
                    let SearchResponse = try JSONDecoder().decode([product].self, from: data)
                    DispatchQueue.main.async {
                        self.products = SearchResponse
                        self.error = nil
                        print("by description : products=")
                        print(self.products)
                    }
                }
                catch{
                    self.error = error
                }
            }
            else if let error{
                self.error = error
            }
        }.resume()
    }
    func getProductByPriceBetween(PriceFrom:Int, PriceTo:Int)
    {
        let urlString = "http://localhost:8080/pricebetween?pricefrom=\(PriceFrom)&priceto=\(PriceTo)"
        print(urlString)
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
                  error = FetchError.invalidURL
                  return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do{
                    let SearchResponse = try JSONDecoder().decode([product].self, from: data)
                    DispatchQueue.main.async {
                        self.products = SearchResponse
                        self.error = nil
                        print("by priceBetween : products=")
                        print(self.products)
                    }
                }
                catch{
                    self.error = error
                }
            }
            else if let error{
                self.error = error
            }
        }.resume()
    }
    func getProductByOneDate(date:String)
    {
        let urlString = "http://localhost:8080/date?date=\(date)"
        print(urlString)
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
                  error = FetchError.invalidURL
                  return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do{
                    let SearchResponse = try JSONDecoder().decode([product].self, from: data)
                    DispatchQueue.main.async {
                        self.datIncome = 0
                        self.datExpense = 0
                        self.datTotal = 0
                        
                        self.products = SearchResponse
                        self.error = nil
                        for item in self.products
                        {
                            if(item.accountingType == "income")
                            {
                                self.datTotal = item.price + self.datTotal
                                self.datIncome = item.price + self.datIncome
                            }
                            else
                            {
                                self.datTotal = self.datTotal - item.price
                                self.datExpense = self.datExpense - item.price
                            }
                        }
                        print("by one date")
                        print(self.products)
                    }
                }
                catch{
                    self.error = error
                    print("error1=")
                    print(error)
                }
            }
            else if let error{
                self.error = error
                print("error2=")
                print(error)
            }
        }.resume()
    }
}
