//
//  ViewController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/16/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let plusButtonPhoto: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plusphoto"), for: .normal)
        button.addTarget(self, action: #selector(handleAvaImagePicker), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAvaImagePicker(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusButtonPhoto.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusButtonPhoto.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
        plusButtonPhoto.layer.cornerRadius = plusButtonPhoto.frame.width/2
        plusButtonPhoto.layer.masksToBounds = true
    }
    
    let emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.borderStyle = .roundedRect
        email.backgroundColor = UIColor(white: 0, alpha: 0.03)
        email.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
        return email
    }()
    
    @objc func handleEditing(){
        if emailTextField.text != "" && passwordTextField.text != "" {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let usernameTextField: UITextField = {
        let username = UITextField()
        username.placeholder = "Username"
        username.borderStyle = .roundedRect
        username.backgroundColor = UIColor(white: 0, alpha: 0.03)
        username.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
        return username
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignIn(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                print("Creat user failed!!!")
                return
            }
            print("Created success!")
            guard let avaImage = self.plusButtonPhoto.imageView?.image else{ return }
            guard let uploadData = avaImage.jpegData(compressionQuality: 0.3) else{ return }
            Storage.storage().reference().child("images/\(user.uid)").putData(uploadData, metadata: nil) { (metadata, error) in
                Storage.storage().reference().child("images/\(user.uid)").downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    let avaImageUrl:String = downloadURL.absoluteString
                    let values = ["username":self.usernameTextField.text!,"avaImageUrl":avaImageUrl,"uid":user.uid] as [String : Any]
                    Database.database().reference().child("users:").child(user.uid).setValue(values)
                    print("successfully save to db")
                    guard let mainTabbarcController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else{return}
                    mainTabbarcController.setupTabbarcontroller()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "Password "
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.backgroundColor = UIColor(white: 0, alpha: 0.03)
        password.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
        return password
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font  : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributeText.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributeText, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignIn(){
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupLayout()
        setUpcontainer()
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, paddingtop: 0, left: view.leftAnchor, paddingleft: 12, right: view.rightAnchor, paddingright: -12, bot: view.bottomAnchor, botpadding: -12, height: 20, width: 0)
    }
    
    func setupLayout(){
        view.addSubview(plusButtonPhoto)
        plusButtonPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButtonPhoto.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingtop: 20, left: nil, paddingleft: 0, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 140, width: 140)
    }
    
    func setUpcontainer(){
        let singupContainer = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        view.addSubview(singupContainer)
        singupContainer.distribution = .fillEqually
        singupContainer.axis = .vertical
        singupContainer.spacing = 10
        
        singupContainer.anchor(top: plusButtonPhoto.bottomAnchor, paddingtop: 20, left: view.safeAreaLayoutGuide.leftAnchor, paddingleft: 30, right: view.safeAreaLayoutGuide.rightAnchor, paddingright: -30, bot: nil, botpadding: 0, height: 200, width: 0)
    }
}


