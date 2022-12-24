//
//  firstCollectionViewCell.swift
//  YummyFoods
//
//  Created by Eldaniz on 22.12.22.
//

import UIKit

class firstCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryBack: UIView!{
        didSet{
            self.categoryBack.layer.cornerRadius = 15
            self.categoryBack.layer.borderWidth = 1
            self.categoryBack.layer.borderColor = UIColor.brown.cgColor
            self.categoryBack.clipsToBounds = true
        }
    }
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        contentView.clipsToBounds = true
    }
    
}
