//
//  DetailVC.swift
//  YummyFoods
//
//  Created by Eldaniz on 23.12.22.
//

import UIKit

class DetailVC: UIViewController {
    var foodItem: Foods?
    var cartItem: FoodsCart?
    var vm = DetailVM()
    var cartVm = CartVM()
    var count = 1
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var stepperLbl: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView(){
        if foodItem != nil{
            nameLbl.text = foodItem?.name
            categoryLbl.text = foodItem?.category
            if let url = URL(string: "http://kasimadalan.pe.hu/foods/images/\(foodItem?.image ?? "")"){
                DispatchQueue.main.async {
                    self.foodImage.kf.setImage(with: url)
                }
            }
            totalPriceLbl.text = "Total Price: \(foodItem?.price ?? 0) $"
            priceLbl.text = "Price: $\(foodItem?.price ?? 0)"
        }else{
            nameLbl.text = cartItem?.name
            categoryLbl.text = cartItem?.category
            if let url = URL(string: "http://kasimadalan.pe.hu/foods/images/\(cartItem?.image ?? "")"){
                DispatchQueue.main.async {
                    self.foodImage.kf.setImage(with: url)
                }
            }
            stepper.value = Double(cartItem?.orderAmount ?? 0)
            stepperLbl.text = "Amount: \(cartItem?.orderAmount ?? 1)"
            totalPriceLbl.text = "Total Price: \((cartItem?.orderAmount ?? 0) * (cartItem?.price ?? 0)) $"
            priceLbl.text = "Price: $\(cartItem?.price ?? 0)"
            addToCartBtn.setTitle("UPDATE", for: .normal)
        }
        
    
        
    }
 
    @IBAction func stepperChanged(_ sender: UIStepper) {
        stepperLbl.text = "Amount: \(Int(sender.value))"
        if foodItem != nil{
            totalPriceLbl.text = "Total Price: \(Int(sender.value) * (foodItem?.price ?? 0)) $"
        }else{
            totalPriceLbl.text = "Total Price: \(Int(sender.value) * (cartItem?.price ?? 0)) $"
        }
        count = Int(sender.value)
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
        if let foodItem{
            let food = FoodsCart(name: foodItem.name!, image: foodItem.image!, price: foodItem.price!, category: foodItem.category!, orderAmount: count, userName: "EA")
            
            vm.addToCart(food: food)
        }
        if let cartItem{
            
            
            let updatedCartItem = FoodsCart(name: cartItem.name!, image: cartItem.image!, price: cartItem.price!, category: cartItem.category!, orderAmount: count, userName: cartItem.userName!)
            
            vm.addToCart(food: updatedCartItem)
            vm.deleteCart(item: cartItem)
        }
        let alertController = UIAlertController(title: "", message: "The order successfully added to the cart", preferredStyle: .alert)
        if foodItem != nil{
            alertController.message = "The order successfully added to the cart!"
        }else{
            alertController.message = "The order successfully updated!"
            self.cartVm.loadCart(userName: "EA")
        }
        

        let okAction = UIAlertAction(title: "OKay", style: .default) { [self] UIAlertAction in
            self.dismiss(animated: true)
            self.cartVm.loadCart(userName: "EA")
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
        
    }
}
