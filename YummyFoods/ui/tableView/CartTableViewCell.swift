//
//  CartTableViewCell.swift
//  YummyFoods
//
//  Created by Gulyaz Huseynova on 24.12.22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var foodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
    }
    
}
