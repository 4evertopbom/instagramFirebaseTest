//
//  CommentController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 2/15/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var post: Post?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        navigationItem.title = "Comments"
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        fetchComment()
    }
    
   
    
    var Comments = [Comment]()
    
    fileprivate func fetchComment(){
        guard let postID = post?.postID else { return }
        ref.child("comment").child(postID).observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let userId = dictionary["userId"] as? String else { return }
            FirebaseApp.fetchUserWithUid(uid: userId, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.Comments.append(comment)
                self.collectionView.reloadData()
            })
            
        }) { (err) in
            print("Failed to fetch comment")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = self.Comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = Comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    let commentTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter some text"
        return tf
    }()

    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()

    @objc func handleSubmit(){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let postId = self.post?.postID ?? ""
        
        let values = ["commentText": commentTextfield.text ?? "", "userId": currentUserUid, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        ref.child("comment").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comment: ",err)
            }
            print("Succesfully inserted comment.")
            self.commentTextfield.text = ""
        }
        
    }

    lazy var containerView: UIView = {
        let cv = UIView()
        cv.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        cv.backgroundColor = .white
        cv.addSubview(commentTextfield)
        cv.addSubview(submitButton)
        commentTextfield.anchor(top: cv.topAnchor, paddingtop: 0, left: cv.leftAnchor, paddingleft: 12, right: submitButton.leftAnchor, paddingright: 4, bot: cv.bottomAnchor, botpadding: 0, height: 0, width: 0)
        submitButton.anchor(top: cv.topAnchor, paddingtop: 0, left: nil, paddingleft: 0, right: cv.rightAnchor, paddingright: -12, bot: cv.bottomAnchor, botpadding: 0, height: 0, width: 50)
        
        let lineSeparatedView = UIView()
        lineSeparatedView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        cv.addSubview(lineSeparatedView)
        lineSeparatedView.anchor(top: cv.topAnchor, paddingtop: 0, left: cv.leftAnchor, paddingleft: 0, right: cv.rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 1, width: 0)
        return cv
    }()

    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

}

