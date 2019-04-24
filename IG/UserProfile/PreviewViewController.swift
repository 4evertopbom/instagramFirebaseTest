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
            guard let imageUrl = unwrappedPost.imageUrl else {return}
            imageView.loadImage(imageUrl: imageUrl)
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
    
    let imageView:ImageCustomView = {
        let iv = ImageCustomView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, paddingtop: 0, left: view.leftAnchor, paddingleft: 0, right: view.rightAnchor, paddingright: 0, bot: view.bottomAnchor, botpadding: 0, height: 0, width: 0)
    }
}
