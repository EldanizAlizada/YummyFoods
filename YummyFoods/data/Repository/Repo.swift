//
//  Repo.swift
//  YummyFoods
//
//  Created by Gulyaz Huseynova on 23.12.22.
//

import Foundation
import Alamofire
import RxSwift

class Repo{
    
    var foods = BehaviorSubject<[Foods]>(value: [Foods]())
    var foodsCart = BehaviorSubject<[FoodsCart]>(value: [FoodsCart]())
    
    func search(searchText:String, categoryList: [Foods]){
            
            if (searchText == "") {
                fetchFoods()
            }
            else{
                foods.onNext([]) //empty list
                 
                var list = [Foods]() //empty list for adding matched elements
                
                for food in categoryList{

                    if let string = food.name{
                    
                        if string.contains(searchText){
                            list.append(food)
                        }
                        self.foods.onNext(list)
                    }
               
                }
            }
        }
    
    func fetchFoods(){
        AF.request("http://kasimadalan.pe.hu/foods/getAllFoods.php",method: .get).response{response in
            if let data = response.data{
                do{
                    let decodedData = try? JSONDecoder().decode(FoodModel.self, from: data)
                    
                    if let list = decodedData?.foods{
                        self.foods.onNext(list)
                    }
                }catch{
                    print(error.localizedDescription)
                }
              
            }
        }
    }
    
    func addToCart(food: FoodsCart){
        
        let params: Parameters = ["name": food.name!, "image": food.image!, "price" : food.price!,  "category": food.category!, "orderAmount": food.orderAmount!, "userName": food.userName!]
        AF.request("http://kasimadalan.pe.hu/foods/insertFood.php", method: .post, parameters: params).response { response in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode(Response.self, from: data)
                    print("Success: \(result.success!)")
                    print("Message: \(result.message!)")
                    self.loadCart(userName: "EA")
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loadCart(userName: String){
        let params: Parameters = ["userName": userName]
        AF.request("http://kasimadalan.pe.hu/foods/getFoodsCart.php", method: .post, parameters: params).response { response in
            
            if let data = response.data{
           
                do{
                   
                    self.foodsCart.onNext([]) //reset remaining one item in cart after deleting all
                    
                    let result = try JSONDecoder().decode(FoodModel.self, from: data)

                    if let list = result.foods_cart{
                        
                        self.foodsCart.onNext(list)
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteCart(item: FoodsCart){
        let id = item.cartId
        let params: Parameters = ["cartId": id, "userName": "EA"]
        AF.request("http://kasimadalan.pe.hu/foods/deleteFood.php", method: .post, parameters: params).response { response in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode(Response.self, from: data)
                    print("Success: \(result.success!)")
                    print("Message: \(result.message!)")
                    self.loadCart(userName: "EA")
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}
