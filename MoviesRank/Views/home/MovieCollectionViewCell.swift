//
//  MovieCollectionViewCell.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 3/31/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureAppereance() {
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = UIColor.clear.cgColor
        self.containerView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
}
