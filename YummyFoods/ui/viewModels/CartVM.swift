//
//  CartScreenVM.swift
//  YummyFoods
//
//  Created by Gulyaz Huseynova on 23.12.22.
//

import Foundation
import Alamofire
import RxSwift

class CartVM{
    
    var foodsCart = BehaviorSubject<[FoodsCart]>(value: [FoodsCart]())
    
    var repo = Repo()
    
    init(){
        loadCart(userName: "EA")

        foodsCart = repo.foodsCart
    }
    
    
    func loadCart(userName: String){
        repo.loadCart(userName: userName)
    }
    func deleteCart(item: FoodsCart){
        repo.deleteCart(item: item)
    }
    
}
