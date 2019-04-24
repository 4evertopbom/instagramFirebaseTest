//
//  ImageCustomView.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/1/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

var imageCache = [String:UIImage]()
class ImageCustomView: UIImageView {
    
    var lastImageUrl: String?
    
    func loadImage(imageUrl: String){
        lastImageUrl = imageUrl
        
        self.image = nil
        
        if let cachedImage = imageCache[imageUrl] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, respone, err ) in
            if url.absoluteString != self.lastImageUrl {
                return
            }
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
