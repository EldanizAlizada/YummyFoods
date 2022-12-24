//
//  CartVC.swift
//  YummyFoods
//
//  Created by Eldaniz on 23.12.22.
//

import UIKit
import Kingfisher
import RxSwift

class CartVC: UIViewController {
    var didselectIndex = 0
    var foodsCart = [FoodsCart]()
    var vm = CartVM()
    
    @IBOutlet weak var totalOrderPrice: UILabel!
    @IBOutlet weak var finishBack: UIView!{
        didSet{
            finishBack.layer.cornerRadius = 10
            finishBack.layer.borderWidth = 1
            finishBack.layer.borderColor = UIColor.brown.cgColor
            finishBack.isHidden = true
        }
    }
    @IBOutlet weak var finishOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = vm.foodsCart.subscribe(onNext: { [self] item in
            DispatchQueue.main.async {
                self.foodsCart = item
                self.tableView.reloadData()

            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.loadCart(userName: "EA")
    }
    


}

extension CartVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodsCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        let food = self.foodsCart[indexPath.row]
        
        if let url = URL(string: "http://kasimadalan.pe.hu/foods/images/\(food.image ?? "")"){
            DispatchQueue.main.async {
                cell.foodImage.kf.setImage(with: url)
            }
        }
        cell.foodLabel.text = food.name
        cell.amountLbl.text = "Amount: \(food.orderAmount ?? 0)"
        cell.priceLbl.text = "Total Price: \((food.price ?? 0) * (food.orderAmount ?? 0)) $"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove from Cart"){
            (action,view,bool) in
            
            let item = self.foodsCart[indexPath.row]
            
            let alert = UIAlertController(title: "Remove from Cart", message: "Do you want to remove \(item.name!) ?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive){ action in
                print("\(item.name!) deleted")
                
                self.vm.deleteCart(item: item)
                self.tableView.reloadData()
                
                
            }
            alert.addAction(yesAction)
            self.present(alert, animated: true)
            
            
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didselectIndex = indexPath.row
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        nextVC.cartItem = foodsCart[didselectIndex]
        print("aa", foodsCart[didselectIndex].name!)
        present(nextVC,animated: true,completion: nil)
    }
}
