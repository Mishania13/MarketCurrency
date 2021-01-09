//
//  CustomTableViewCell.swift
//  MarketCurrency
//
//  Created by Mr. Bear on 03.09.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var color: String = "gray" {
        didSet {
            percentChangeLabel.textColor = UIColor(named: color)
            priceLabel.textColor = UIColor(named: color)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var action: (() -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteButtonPressed () {
        self.action?()
    }
}
