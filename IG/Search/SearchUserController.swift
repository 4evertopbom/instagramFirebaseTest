//
//  File.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/10/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Firebase

class SearchUserController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellId = "cellId"
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return sb
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: cellId)
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.anchor(top: navBar?.topAnchor, paddingtop: 0, left: navBar?.leftAnchor, paddingleft: 8, right: navBar?.rightAnchor, paddingright: -8, bot: navBar?.bottomAnchor, botpadding: 0, height: 0, width: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
        userProfileController.userID = searchUsers[indexPath.item].uid
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            searchUsers = users
        }
        else {
            searchUsers = self.users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
        }
        self.collectionView.reloadData()
    }
    
    var users = [User]()
    var searchUsers = [User]()
    
    fileprivate func fetchUsers(){
        ref.child("users:").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                guard let username = dictionary["username"] as? String else { return }
                guard let avaImageUrl = dictionary["avaImageUrl"] as? String else { return }
                let user = User(username: username, avaImageUrl: avaImageUrl, uid: uid)
                if(user.uid == Auth.auth().currentUser?.uid) {
                    // DO NOTHING
                }
                else {
                    self.users.append(user)
                }
                
            })
            self.searchUsers = self.users
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchUserCell
        cell.user = searchUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}
