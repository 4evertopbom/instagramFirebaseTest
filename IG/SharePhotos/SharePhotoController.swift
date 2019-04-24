//
//  SharePhotoController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/29/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Firebase


class SharePhotoController: UIViewController {
    
    var selectedImage:UIImage? {
        didSet{
            self.photoImageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        setUpImagesandTextsView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let captionTextView: UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 14)
        return textview
    }()
    
    fileprivate func setUpImagesandTextsView(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingtop: 0, left: view.leftAnchor, paddingleft: 0, right: view.rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 100, width: 0)
        containerView.addSubview(photoImageView)
        photoImageView.anchor(top: containerView.topAnchor, paddingtop: 8, left: containerView.leftAnchor, paddingleft: 8, right: nil, paddingright: 0, bot: containerView.bottomAnchor, botpadding: -8, height: 0, width: 84)
        containerView.addSubview(captionTextView)
        captionTextView.anchor(top: containerView.topAnchor, paddingtop: 0, left: photoImageView.rightAnchor, paddingleft: 4, right: containerView.rightAnchor, paddingright: 0, bot: containerView.bottomAnchor, botpadding: 0, height: 0, width: 0)
    }
    
    @objc func handleShare(){
        guard let image = selectedImage else { return }
        guard let data = image.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        navigationItem.rightBarButtonItem?.isEnabled = false
        Storage.storage().reference().child("posts").child(filename).putData(data, metadata: nil) { (metadata, error) in
            if let err = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload image to storage")
                print(err)
                return
            }
            print("successfully upload image to storage ")
            Storage.storage().reference().child("posts").child(filename).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                let imageUrl = downloadURL.absoluteString
                print(imageUrl)
                self.saveToDatabaseWithImageUrl(ImageUrl: imageUrl)
            }
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    fileprivate func saveToDatabaseWithImageUrl(ImageUrl: String){
        guard let postImage = selectedImage else {return}
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if captionTextView.text == nil {
            captionTextView.text = ""
        }
        let values = ["imageUrl:": ImageUrl, "caption:": captionTextView.text, "imageWidth:": postImage.size.width, "imageHeight:": postImage.size.height,"creationDate:": Date().timeIntervalSince1970 ] as [String : Any]
        Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(values) { (err, DatabaseReference) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("failed to upload to Database")
                print(err)
                return
            }
            print("successfully upload to database")
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
}
