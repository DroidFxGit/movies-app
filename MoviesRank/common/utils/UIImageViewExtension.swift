//
//  UIImageViewExtension.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/8/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import UIKit

typealias completionBlock = (_ image: UIImage) -> Void

extension UIImageView {
    func imageFromUrl(url: String, placeholderImage: String? = nil) {
        let temporalImage = UIImage(named: placeholderImage ?? "")
        self.image = temporalImage
        downloadImageFromUrl(urlString: url) { image in
            self.image = image
        }
    }
    
    private func downloadImageFromUrl(urlString: String, completion: @escaping completionBlock) {
        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
}
