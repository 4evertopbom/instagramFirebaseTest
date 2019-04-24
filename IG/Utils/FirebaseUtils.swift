//
//  FirebaseUtils.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/9/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import Foundation
import Firebase

extension FirebaseApp {
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> () ){
        ref.child("users:").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            let username = value["username"] as! String
            let avaImageUrl = value["avaImageUrl"] as! String
            let uid = value["uid"] as! String
            let user = User(username: username, avaImageUrl: avaImageUrl, uid: uid)
            completion(user)
        }
    }
}
