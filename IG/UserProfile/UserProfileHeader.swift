//
//  UserProfileHeader.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/19/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileDelegate: class {
    func didtapListView()
    func didtapGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var user:User? {
        didSet{
            guard let unwrappedUser = user else {return}
            guard let imageUrl = unwrappedUser.avaImageUrl else { return }
            profileImageView.loadImage(imageUrl: imageUrl)
            usernameLabel.text = unwrappedUser.username
            
            self.setUpEditFollowButton()
        }
    }
    
    fileprivate func setUpEditFollowButton(){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if currentUserUid == userId {
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        }
        else {
            ref.child("Following").child(currentUserUid).child(userId).observeSingleEvent(of: .value) { (snapshot) in
                let check = snapshot.value as? Int
                if check == 1 {
                    self.setUpUnfollowButton()
                }
                else {
                    self.setUpFollowButton()
                }
            }
        }
    }
    
    fileprivate func setUpFollowButton(){
        editProfileFollowButton.setTitle("Follow", for: .normal)
        editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 134, blue: 237)
        editProfileFollowButton.setTitleColor(.white, for: .normal)
    }
    
    fileprivate func setUpUnfollowButton(){
        editProfileFollowButton.setTitle("Unfollow", for: .normal)
        editProfileFollowButton.backgroundColor = .white
        editProfileFollowButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func handleEditProfileFollow(){
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if (currentUserId == userId){
            print("TOUCHING.......")
        }
        else{
            if (editProfileFollowButton.titleLabel?.text == "Follow"){
                let value = [userId: 1]
                ref.child("Following").child(currentUserId).updateChildValues(value)
                setUpUnfollowButton()
            }
            else {
                ref.child("Following").child(currentUserId).child(userId).removeValue()
                setUpFollowButton()
            }
        }
    }
    
    let profileImageView:ImageCustomView = {
        let imageView = ImageCustomView()
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleGridView), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.addTarget(self, action: #selector(handleListView), for: .touchUpInside)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    weak var protocolDelegate: UserProfileDelegate?
    
    @objc func handleGridView(){
        protocolDelegate?.didtapGridView()
        gridButton.tintColor = UIColor.rgb(red: 17, green: 134, blue: 237)
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    @objc func handleListView(){
        protocolDelegate?.didtapListView()
        listButton.tintColor = UIColor.rgb(red: 17, green: 134, blue: 237)
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let ribbonButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        let attributeText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font :UIFont.boldSystemFont(ofSize: 16)])
        attributeText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributeText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersButton: UIButton = {
        let button = UIButton()
        let attributeText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font :UIFont.boldSystemFont(ofSize: 16)])
        attributeText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        button.setAttributedTitle(attributeText, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let followingButton: UIButton = {
        let button = UIButton()
        let attributeText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font :UIFont.boldSystemFont(ofSize: 16)])
        attributeText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        button.setAttributedTitle(attributeText, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()

    lazy var editProfileFollowButton:UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .black
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupBottomToolBar(){
        let divideTopView = UIView()
        divideTopView.backgroundColor = UIColor.lightGray
        let divideBotView = UIView()
        divideBotView.backgroundColor = UIColor.lightGray
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, ribbonButton])
        self.addSubview(stackView)
        self.addSubview(divideBotView)
        self.addSubview(divideTopView)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.anchor(top: usernameLabel.bottomAnchor, paddingtop: 0, left: leftAnchor, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 49, width: 0)
        
        divideTopView.anchor(top: gridButton.topAnchor, paddingtop: 0, left: leftAnchor, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 0.5, width: 0)
        divideBotView.anchor(top: gridButton.bottomAnchor, paddingtop: 0, left: leftAnchor, paddingleft: 0, right: rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 0.5, width: 0)
    }
    
    fileprivate func setupUserStatsView(){
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersButton, followingButton])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, paddingtop: 12, left: profileImageView.rightAnchor, paddingleft: 12, right: rightAnchor, paddingright: -4, bot: nil, botpadding: 0, height: 45, width: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, paddingtop: 12, left: leftAnchor, paddingleft: 12, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 80, width: 80)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, paddingtop: 4, left: leftAnchor, paddingleft: 12, right: rightAnchor, paddingright: 12, bot: nil, botpadding: 0, height: 55, width: 0)
        
        setupBottomToolBar()
        setupUserStatsView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, paddingtop: 5, left: profileImageView.rightAnchor, paddingleft: 12, right: rightAnchor, paddingright: -12, bot: nil, botpadding: 0, height: 25, width: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
