//
//  User.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/19/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit

struct User {
    let username: String!
    let avaImageUrl: String!
    let uid:String!
    
    init(username: String, avaImageUrl: String, uid:String) {
        self.username = username
        self.avaImageUrl = avaImageUrl
        self.uid = uid
    }
    
}
