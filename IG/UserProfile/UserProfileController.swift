//
//  UserProfileController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/18/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//
import UIKit
import Firebase

let ref : DatabaseReference = Database.database().reference()
class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileDelegate,UserPostDelegate {
    func didtapComment(post: Post) {
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    var user:User?
    let cellId = "cellId"
    let homepostcellId = "homepostcellId"
    var selectedPost: Post?
    
    var userID: String?
    
    var isGrid = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpnavigation()
        fetchUser()
       
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
    }
    
    func setUpnavigation(){
        collectionView.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homepostcellId)
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)

    }
    
    func didtapListView() {
        isGrid = false
        collectionView.reloadData()
    }
    
    func didtapGridView() {
        isGrid = true
        collectionView.reloadData()
    }
    
    @objc func handleLogOut(){
        let alertLogOut:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutButton:UIAlertAction = UIAlertAction(title: "Log Out", style: .destructive) { (_ ) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let signInController = UINavigationController(rootViewController: SignInController())
                self.present(signInController, animated: true, completion: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        let cancelButton:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertLogOut.addAction(logoutButton)
        alertLogOut.addAction(cancelButton)
        self.present(alertLogOut, animated: true,completion: nil)
    }
    
     func fetchUser(){
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = userID ?? (currentUser.uid)
        FirebaseApp.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            self.fetchOrderPosts()
        }
    }
    
    var posts = [Post]()
    
    fileprivate func fetchOrderPosts(){
        guard let currentUseruid = Auth.auth().currentUser?.uid else { return }
        guard let uid = self.user?.uid else { return }
        ref.child("posts").child(uid).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let thisUser = self.user else { return }
            var post = Post(user: thisUser, dictionary: dictionary)
            post.postID = snapshot.key
            ref.child("like").child(currentUseruid).child(post.postID!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Int, value == 1 {
                    post.isLike = true
                } else {
                    post.isLike = false
                }
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()
            })
        }
    }
    // .childAdded and .value have different snapshot.value
    
//    func fetchUserProfile(){
//        guard let currentUser = Auth.auth().currentUser else { return }
//        ref.child("posts").child(currentUser.uid).observe(.value, with: { (snapshot) in
//            guard let dictionaries = snapshot.value as? [String:Any] else {return}
//            dictionaries.forEach({ (key,value) in
//                guard let dictionary = value as? [String:Any] else {return}
//                let post = Post(dictionary: dictionary)
//                self.posts.append(post)
//            })
//            self.collectionView.reloadData()
//        })
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGrid == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homepostcellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            cell.userPostDelegate = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid == true {
            let width = (view.frame.width-2)/3
            return CGSize(width: width, height: width)
        } else {
            var height:CGFloat = 8 + 40 + 8 + 50 + 60
            height += view.frame.width
            return CGSize(width: view.frame.width, height: height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = user
        header.protocolDelegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isGrid == true {
            let singlePostController = SinglePostController(collectionViewLayout: UICollectionViewFlowLayout())
            singlePostController.post = self.posts[indexPath.item]
            navigationController?.pushViewController(singlePostController, animated: true)
        }
    }
}

extension UserProfileController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if isGrid == false {
            return nil
        }
        guard let indexPath = collectionView.indexPathForItem(at: location), let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        let previewVC = PreviewViewController()
        previewVC.post = posts[indexPath.item]
        selectedPost = posts[indexPath.item]
        
        previewVC.preferredContentSize = CGSize(width: 0, height: 400)
        
        previewingContext.sourceRect = cell.frame
        
        return previewVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let singlePostController = SinglePostController(collectionViewLayout: UICollectionViewFlowLayout())
        singlePostController.post = selectedPost
        show(singlePostController, sender: self)
    }
}
