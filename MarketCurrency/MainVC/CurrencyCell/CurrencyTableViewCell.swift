//
//  CurrencyTableViewCell.swift
//  MarketCurrency
//
//  Created by Звягинцев Михаил on 22.11.2020.
//  Copyright © 2020 Звягинцев Михаил. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel: CurrencyCellViewModelProtocol! {
        
        didSet {
            nameLabel.text = viewModel.name
            percentChangeLabel.text = viewModel.percentChange
            priceLabel.text = viewModel.amount
            
            favoriteButton.setImage(UIImage(systemName: viewModel.getImageName()), for: .normal)
            
            percentChangeLabel.textColor = viewModel.priceAndPercentColor
            priceLabel.textColor = viewModel.priceAndPercentColor
        }
    }
    
    @IBAction private func favoriteButtonPressed(sender: UIButton!) {
        
        viewModel.changeFavoriteStatus()
        UIView.transition(
            with: favoriteButton,
            duration: 0.3,
            options: .transitionFlipFromRight,
            animations: {
                self.favoriteButton.setImage(UIImage(systemName: self.viewModel.getImageName()), for: .normal)
            },
        completion: nil)
    }
}
