//
//  Post.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/30/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

struct Post {
    var postID: String?
    
    
    var isLike: Bool
    let imageUrl: String!
    let user: User!
    let caption: String!
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl:"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption:"] as? String ?? ""
        self.isLike = false
        
        let secondfrom1970 = dictionary["creationDate:"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondfrom1970)
    }
}
