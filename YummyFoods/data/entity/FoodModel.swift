//
//  FoodModel.swift
//  YummyFoods
//
//  Created by Eldaniz on 21.12.22.
//

import Foundation

class Response: Codable {
    var success: Int?
    var message: String?
}

class FoodModel: Codable{
    var foods: [Foods]?
    var foods_cart: [FoodsCart]?
    
}
class Foods: Codable{
    var id: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    
    init(id: Int, name: String, image: String, price: Int, category: String) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.category = category
    }
}

class FoodsCart: Codable{
    var cartId: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var orderAmount: Int?
    var userName: String?
    
    internal init(name: String, image: String, price: Int, category: String, orderAmount: Int, userName: String) {
        
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.orderAmount = orderAmount
        self.userName = userName
    
    }
}
