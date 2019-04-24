//
//  PhotosSelectorCell.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/26/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

class PhotosSelectorCell: UICollectionViewCell {
    
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, paddingtop: 0, left: leftAnchor, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: bottomAnchor, botpadding: 0, height: 0, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
