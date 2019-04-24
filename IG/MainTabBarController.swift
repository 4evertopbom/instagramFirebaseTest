//
//  MainTabBarController.swift
//  IG
//
//  Created by Hoang Anh Tuan on 1/18/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            let signInController = UINavigationController(rootViewController: SignInController())
            DispatchQueue.main.async {
                self.present(signInController, animated: true,completion: nil)
            }
            return
        }
        self.delegate = self
        setupTabbarcontroller()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoController)
            self.present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func setupTabbarcontroller(){
        
        let layout = UICollectionViewFlowLayout()
        let homeController = templateController(selected: "home selected", unselected: "home unselected", rootViewController: HomeController(collectionViewLayout: layout))
        
        let searchController = templateController(selected: "search selected", unselected: "search unselected", rootViewController: SearchUserController(collectionViewLayout: layout))
        
        let plusController = templateController(selected: "plus ", unselected: "plus")
        
        let notifyController = templateController(selected: "love selected", unselected: "love unselected")
        
        let userProfileController = templateController(selected: "user selected", unselected: "user unselect", rootViewController: UserProfileController(collectionViewLayout: layout))
        
        viewControllers = [homeController, searchController, plusController, notifyController, userProfileController]
        tabBar.tintColor = .black
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    func templateController(selected: String, unselected: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        let viewcontroller = rootViewController
        let navController = UINavigationController(rootViewController: viewcontroller)
        navController.tabBarItem.image = UIImage(named: unselected)
        navController.tabBarItem.selectedImage = UIImage(named: selected)
        return navController
    }
}
