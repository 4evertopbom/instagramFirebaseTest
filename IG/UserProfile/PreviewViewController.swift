//
//  UserProfileControllerPreviewing.swift
//  IG
//
//  Created by Hoang Anh Tuan on 4/23/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {
    
    var post:Post? {
        didSet{
            guard let unwrappedPost = post else { return }
            guard let imageUrl = unwrappedPost.imageUrl else { return }
            
            guard let user = unwrappedPost.user else { return }
            guard let profileImageUrl = user.avaImageUrl else { return }
            DispatchQueue.main.async {
                self.imageView.loadImage(imageUrl: imageUrl)
                self.profileImageView.loadImage(imageUrl: profileImageUrl)
                self.nameLabel.text = user.username
            }
        }
    }
    
    var previewActions: [UIPreviewActionItem] {
        let item1 = UIPreviewAction(title: "Like", style: .default, handler: { (action, viewcontroller) in
            print("Like")
        })
        
        let item2 = UIPreviewAction(title: "Comment", style: .default, handler: { (action, viewcontroller) in
            print("Comment")
        })
        
        return [item1, item2]
    }
    
    let profileImageView: ImageCustomView = {
        let iv = ImageCustomView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.textColor = .black
        return lb
    }()
    
    let imageView:ImageCustomView = {
        let iv = ImageCustomView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(imageView)
        
        profileImageView.anchor(top: view.topAnchor, paddingtop: 8, left: view.leftAnchor, paddingleft: 12, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        nameLabel.anchor(top: profileImageView.topAnchor, paddingtop: 0, left: profileImageView.rightAnchor, paddingleft: 8, right: view.rightAnchor, paddingright: 0, bot: profileImageView.bottomAnchor, botpadding: 0, height: 0, width: 0)
        
        imageView.anchor(top: profileImageView.bottomAnchor, paddingtop: 12, left: view.leftAnchor, paddingleft: 0, right: view.rightAnchor, paddingright: 0, bot: view.bottomAnchor, botpadding: 0, height: 0, width: 0)
    }
}
