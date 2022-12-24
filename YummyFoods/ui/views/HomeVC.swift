//
//  ViewController.swift
//  YummyFoods
//
//  Created by Eldaniz on 19.12.22.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    var currentSelected = 0
    var categories: [String] = ["All Food"]
    var vm = HomeVM()
    var foodList: [Foods] = []
    var changingFoodList: [Foods] = []
    
    
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            profileImage.layer.cornerRadius = 25
            profileImage.layer.borderWidth = 1
            profileImage.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var sloganLbl: UILabel!
    @IBOutlet weak var textField: UISearchBar!{
        didSet{
            textField.clipsToBounds = true
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 10
            textField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    @IBOutlet weak var secondCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        firstCollectionView.dataSource = self
        secondCollectionView.dataSource = self
        firstCollectionView.delegate = self
        secondCollectionView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchFoods()
    }
    
    func setBindings(){
        
        _ = vm.foods.subscribe(onNext: { [self] item in
            DispatchQueue.main.async {
                self.foodList = item
                self.changingFoodList = item
                self.secondCollectionView.reloadData()
                for i in self.foodList{
                    if !self.categories.contains(i.category ?? ""){
                        self.categories.append(i.category ?? "")
                    }
                    self.firstCollectionView.reloadData()
                }

            }
        })
        
    }

}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case firstCollectionView:
            return categories.count
        case secondCollectionView:
            return changingFoodList.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case firstCollectionView:
            let category = categories[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! firstCollectionViewCell
            cell.categoryLbl.text = category
            cell.categoryBack.backgroundColor = currentSelected == indexPath.row ? UIColor.lightGray : UIColor.white
            cell.categoryLbl.textColor = currentSelected == indexPath.row ? UIColor.white : UIColor.orange
            return cell
        case secondCollectionView:
            let food = changingFoodList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! secondCollectionViewCell
            if let url = URL(string: "http://kasimadalan.pe.hu/foods/images/\(food.image ?? "")"){
                DispatchQueue.main.async {
                    cell.foodImage.kf.setImage(with: url)
                }
            }
            cell.nameLbl.text = food.name
            cell.descriptionNameLbl.text = "Category: \(food.category ?? "" )"
            cell.priceLbl.text = "$\(food.price ?? 0)"
            return cell
        default:
            fatalError()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case firstCollectionView:
            currentSelected = indexPath.row
            
            changingFoodList = []
            if categories[indexPath.row] == "All Food"{
                changingFoodList = foodList
            }else{
                for i in foodList{
                    if i.category == categories[indexPath.row]{
                        changingFoodList.append(i)
                    }
                }
            }
            firstCollectionView.reloadData()
            secondCollectionView.reloadData()
            
        case secondCollectionView:
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
            nextVC.foodItem = changingFoodList[indexPath.row]
            present(nextVC,animated: true,completion: nil)
        default:
           break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case firstCollectionView:
            let label = UILabel(frame: CGRect.zero)
            label.text = categories[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 40, height: 60)
        case secondCollectionView:
            return CGSize(width: UIScreen.main.bounds.width * 0.483, height: UIScreen.main.bounds.height * 0.335)
        default:
            fatalError()
        }
    }
}


extension HomeVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.search(searchText: searchText, categoryList: foodList)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        self.textField.endEditing(true)
        
    }
}
