//
//  HomeScreenVM.swift
//  YummyFoods
//
//  Created by Eldaniz on 21.12.22.
//

import Foundation
import RxSwift


class HomeVM{
    
    var repo = Repo()
    
    var foods = BehaviorSubject<[Foods]>(value: [Foods]())
    
    
    init(){
        fetchFoods()
        
        foods = repo.foods
       
    }
    
    func fetchFoods() {
        repo.fetchFoods()
    }
    func search(searchText:String, filterList: [Foods]){
        repo.search(searchText: searchText, filterList: filterList)
    }

    
}
 
