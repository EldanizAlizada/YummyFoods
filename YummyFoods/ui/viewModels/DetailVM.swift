//
//  DetailScreenVM.swift
//  YummyFoods
//
//  Created by Gulyaz Huseynova on 23.12.22.
//

import Foundation
import Alamofire
import RxSwift

class DetailVM{
    
    var repo = Repo()
    
    func addToCart(food: FoodsCart){
        repo.addToCart(food: food)
    }
    func deleteCart(item: FoodsCart){
        repo.deleteCart(item: item)
    }
    

    
}
