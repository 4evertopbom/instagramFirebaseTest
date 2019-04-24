//
//  SignInController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/24/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInController: UIViewController {
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let logoinHeader: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ins")
        iv.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return iv
    }()
    
    let emailTextField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.backgroundColor = UIColor.init(white: 0, alpha: 0.03)
        textfield.borderStyle = .roundedRect
        textfield.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
        return textfield
    }()
    
    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = UIColor.init(white: 0, alpha: 0.03)
        textfield.borderStyle = .roundedRect
        textfield.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
        return textfield
    }()
    
    @objc func handleEditing(){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            logInButton.isEnabled = false
            logInButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        else{
            logInButton.isEnabled = true
            logInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
    }
    
    let logInButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Log in failed! ",err)
                return
            }
            print("Log in success!!")
            
            guard let maintabbarcontroller = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            maintabbarcontroller.setupTabbarcontroller()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func setUpLoginContainer(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,logInButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.anchor(top: headerView.bottomAnchor, paddingtop: 20, left: view.leftAnchor, paddingleft: 12, right: view.rightAnchor, paddingright: -12, bot: nil, botpadding: 0, height: 150, width: 0)
    }
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeText = NSMutableAttributedString(string: "Dont have an account?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributeText.append(NSAttributedString(string: " Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributeText, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp(){
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, paddingtop: 0, left: view.leftAnchor, paddingleft: 12, right: view.rightAnchor, paddingright: -12, bot: view.bottomAnchor, botpadding: -12, height: 20, width: 0)
        
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, paddingtop: 0, left: view.leftAnchor, paddingleft: 0, right: view.rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 150, width: 0)
        headerView.addSubview(logoinHeader)
        logoinHeader.translatesAutoresizingMaskIntoConstraints = false
        logoinHeader.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        logoinHeader.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        setUpLoginContainer()
    }
    
}
