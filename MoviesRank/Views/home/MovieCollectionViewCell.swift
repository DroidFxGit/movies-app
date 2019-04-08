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
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    fileprivate let imageBaseUrl = "https://image.tmdb.org/t/p/w200"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: MoviedbDetail) {
        configureAppearance()
        
        titleMovieLabel.text = model.movieResults[0].title
        yearLabel.text = model.movieResults[0].date
        overviewLabel.text = model.movieResults[0].overview
        
        let imageUrl = imageBaseUrl + model.movieResults[0].posterPath
        posterImageView.imageFromUrl(url: imageUrl, placeholderImage: "placeholder-movie")
    }

    private func configureAppearance() {
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
