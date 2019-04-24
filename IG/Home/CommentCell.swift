//
//  CommentCell.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/16/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet{
            guard let unwrappedComment = comment else { return }
            
            profileImageView.loadImage(imageUrl: unwrappedComment.user.avaImageUrl)
            
            let attributedText = NSMutableAttributedString(string: unwrappedComment.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + unwrappedComment.commentText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributedText
        }
    }
    
    let profileImageView: ImageCustomView = {
        let iv = ImageCustomView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.backgroundColor = .white
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        addSubview(profileImageView)
        textView.anchor(top: topAnchor, paddingtop: 0, left: profileImageView.rightAnchor, paddingleft: 8, right: rightAnchor, paddingright: -12, bot: bottomAnchor, botpadding: 0, height: 0, width: 0)
        profileImageView.anchor(top: topAnchor, paddingtop: 8, left: leftAnchor, paddingleft: 8, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
