//
//  SearchUserCell.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/10/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

class SearchUserCell: UICollectionViewCell {
    
    var user: User? {
        didSet{
            guard let unwrappedUser = user else { return }
            profileImageView.loadImage(imageUrl: unwrappedUser.avaImageUrl)
            usernameLabel.text = unwrappedUser.username
        }
    }
    
    let profileImageView: ImageCustomView = {
        let iv = ImageCustomView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, paddingtop: 0, left: leftAnchor, paddingleft: 8, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 50, width: 50)
        profileImageView.layer.cornerRadius = 25
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, paddingtop: 0, left: profileImageView.rightAnchor, paddingleft: 8, right: rightAnchor, paddingright: 0, bot: bottomAnchor, botpadding: 0, height: 0, width: 0)
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = .black
        separatorView.anchor(top: nil, paddingtop: 0, left: usernameLabel.leftAnchor, paddingleft: 0, right: usernameLabel.rightAnchor, paddingright: 0, bot: bottomAnchor, botpadding: 0, height: 0.5, width: 0 )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
