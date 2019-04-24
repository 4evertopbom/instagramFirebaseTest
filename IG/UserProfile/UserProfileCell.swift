//
//  UserProfileCell.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/30/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    var post:Post? {
        didSet{
            guard let unwrappedPost = post else { return }
            guard let imageUrl = unwrappedPost.imageUrl else {return}
            imageView.loadImage(imageUrl: imageUrl)
        }
    }
    
    let imageView:ImageCustomView = {
        let iv = ImageCustomView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, paddingtop: 0, left: leftAnchor, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: bottomAnchor, botpadding: 0, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
