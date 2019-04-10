//
//  MoviesDataSource.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/9/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation
import UIKit

enum SourceType {
    case trending
    case search
}

protocol MoviesDataSourceDelegate: class {
    func willBeginDragging(_ scrollView: UIScrollView)
}

class MoviesDataSource<T>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let kSections = 1
    private let itemsPerRow: CGFloat = 1
    private let kHeightRow: CGFloat = 200.0
    private let kHeightFooter: CGFloat = 40.0
    
    private var collectionView: UICollectionView!
    private var dataSource: T!
    private var sourceType: SourceType!
    
    weak var datasourceDelegate: MoviesDataSourceDelegate?
    
    init(collectionView: UICollectionView, data: T, type: SourceType) {
        self.collectionView = collectionView
        self.dataSource = data
        self.sourceType = type
        super.init()
        
        setupDataSource()
    }
    
    func setupDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        collectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let moviesDataSource = dataSource as? HomeViewModel else { fatalError("unexpected data") }
        return moviesDataSource.numberOfMovies
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        guard let moviesDataSource = dataSource as? HomeViewModel else { fatalError("unexpected data") }
        let model = moviesDataSource.getMovie(at: indexPath)
        cell.configure(model: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath)
            footerView.isHidden = true
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if sourceType == .trending {
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0.0, y: 0.0, width: collectionView.bounds.width, height: kHeightFooter)
            view.addSubview(spinner)
            view.isHidden = false
            
            // add delay to simulate loading info
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let strongSelf = self else { return }
                guard let moviesDataSource = strongSelf.dataSource as? HomeViewModel  else { fatalError("unexpected data") }
                moviesDataSource.getMovies()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: kHeightRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: kHeightFooter)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        datasourceDelegate?.willBeginDragging(scrollView)
    }
}
