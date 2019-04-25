//
//  HomeController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/1/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomeControllerDelegate {
    
    let cellId = "cellId"
    
   // var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        setupNavigation()
        fetchAllPosts()
        
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
//        collectionView.addSubview(refreshControl)
        
    }
    fileprivate func setupNavigation(){
        collectionView.backgroundColor = .white
        navigationItem.titleView = UIImageView(image: UIImage(named: "ins"))
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    func didtapComment(post: Post) {
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didtapLike(cell: HomePostCell) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }

        if cell.post?.isLike == false {
            let value = [cell.post?.postID: 1]
            ref.child("like").child(currentUserUid).updateChildValues(value) { (err, ref) in
                if let err = err {
                    print("Failed to Like: ",err)
                    return
                }
                cell.post?.isLike = true
                print("Like success")
            }
        }
        else {
            guard let postID = cell.post?.postID else { return }
            ref.child("like").child(currentUserUid).child(postID).removeValue()
            print("Dislike success")
            cell.post?.isLike = false
        }
    }
    
    
    fileprivate func fetchAllPosts(){
        fetchUserPost()
        fetchFollowingUserPost()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    var posts = [Post]()
    
    fileprivate func fetchUserPost(){
        guard let currentUser = Auth.auth().currentUser else { return }
        FirebaseApp.fetchUserWithUid(uid: currentUser.uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
    }
    
    fileprivate func fetchFollowingUserPost(){
        guard let currentUseruid = Auth.auth().currentUser?.uid else { return }
        ref.child("Following").child(currentUseruid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followingUserUid = snapshot.value as? [String: Any] else { return }
            followingUserUid.forEach({ (key, value) in
                FirebaseApp.fetchUserWithUid(uid: key, completion: { (user) in
                    self.fetchPostWithUser(user: user)
                })
            })
        })
    }
    
    fileprivate func fetchPostWithUser(user: User){
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        ref.child("posts").child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
           // self.collectionView.refreshControl?.endRefreshing()
            dictionaries.forEach({ (key, value) in
               // print(key)
                guard let dictionary = value as? [String:Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.postID = key
                ref.child("like").child(currentUserId).child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.isLike = true
                    } else {
                        post.isLike = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                })
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.selectedDelegate = self
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 8 + 40 + 8 + 50 + 60
        height += view.frame.width
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
