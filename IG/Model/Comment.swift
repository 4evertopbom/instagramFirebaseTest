//
//  Comment.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/16/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    let commentText: String
    let userId: String
    
    init(user: User,dictionary: [String: Any]) {
        self.user = user
        self.commentText = dictionary["commentText"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
    }
}
