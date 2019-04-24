//
//  HomePostCell.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/1/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

protocol HomeControllerDelegate: class {
    func didtapComment(post: Post)
    func didtapLike(cell: HomePostCell)
}

protocol UserPostDelegate {
    func didtapComment(post: Post)
}

class HomePostCell: UICollectionViewCell {
    
    var post:Post? {
        didSet{
            guard let unwrappedPost = post else { return }
            guard let imageUrl = unwrappedPost.imageUrl else { return }
            postImage.loadImage(imageUrl: imageUrl)
            userProfileImageView.loadImage(imageUrl: unwrappedPost.user.avaImageUrl)
            userNameLabel.text = unwrappedPost.user.username
            
            if unwrappedPost.isLike == true {
                likeButton.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "love unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            setupCaptionLabel()
        }
    }
    
    fileprivate func setupCaptionLabel(){
        guard let unwrappedPost = post else { return }
        let attributeText = NSMutableAttributedString(string: unwrappedPost.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributeText.append(NSAttributedString(string:" \(unwrappedPost.caption ?? "")", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributeText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        let timeAgo = unwrappedPost.creationDate.timeAgoDisplay()
        attributeText.append(NSAttributedString(string: timeAgo, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.gray]))
        captionLabel.attributedText = attributeText
    }
    
    let moreOptionsButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let userProfileImageView: ImageCustomView = {
        let iv = ImageCustomView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    let postImage: ImageCustomView = {
        let iv = ImageCustomView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var likeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "love unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc func handleLike() {
        selectedDelegate?.didtapLike(cell: self)
    }
    
    lazy var commentButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    weak var selectedDelegate: HomeControllerDelegate?
    var userPostDelegate: UserPostDelegate?
    
    @objc func handleComment(){
        guard let post = self.post else { return }
        selectedDelegate?.didtapComment(post: post)
        userPostDelegate?.didtapComment(post: post)
    }
    
    let sendMessageButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "message")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImage)
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(moreOptionsButton)
        addSubview(captionLabel)
        
        userProfileImageView.anchor(top: topAnchor, paddingtop: 8, left: leftAnchor, paddingleft: 8, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 40, width: 40)
        userProfileImageView.layer.cornerRadius = 20
        postImage.anchor(top: userProfileImageView.bottomAnchor, paddingtop: 8, left: leftAnchor, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 0, width: 0)
        postImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        userNameLabel.anchor(top: topAnchor, paddingtop: 0, left: userProfileImageView.rightAnchor, paddingleft: 8, right: moreOptionsButton.leftAnchor, paddingright: 0, bot: postImage.topAnchor, botpadding: 0, height: 0, width: 0)
        moreOptionsButton.anchor(top: topAnchor, paddingtop: 0, left: nil, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: postImage.topAnchor, botpadding: 0, height: 0, width: 44)
        
        
        setupActionButtons()
        
        captionLabel.anchor(top: likeButton.bottomAnchor, paddingtop: 0, left: leftAnchor, paddingleft: 4, right: rightAnchor, paddingright: 8, bot: bottomAnchor, botpadding: 0, height: 0, width: 0)
        
        
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: postImage.bottomAnchor, paddingtop: 0, left: leftAnchor, paddingleft: 7, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 50, width: 120)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: postImage.bottomAnchor, paddingtop: 0, left: nil, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 50, width: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
