//
//  MainBarController.swift
//  shustagram
//
//  Created by 徐乾智 on 7/25/21.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        
        viewControllers = [
            createNavController(viewController: homeVC, tabBarImage: #imageLiteral(resourceName: "home")),
            createNavController(viewController: vc, tabBarImage: #imageLiteral(resourceName: "plus")),
            createNavController(viewController: profileVC, tabBarImage: #imageLiteral(resourceName: "user"))
        ]
        
        tabBar.tintColor = .black
    }
    
    var homeVC = HomeViewController()
    var profileVC = ProfileViewController(userId: "")
    
    func refreshPosts() {
        homeVC.fetchPosts()
        profileVC.fetchUserProfile()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewControllers?.firstIndex(of: viewController) == 1 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true)
            return false
        }
        
        return true
    }
    
    fileprivate func createNavController(viewController: UIViewController, tabBarImage: UIImage) -> UIViewController {
            
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        return navController
        
    }
    
}

extension MainTabBarController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                let createPostController = CreatePostViewController(selectedImage: image)
                self.present(createPostController, animated: true)
            }
        } else {
            dismiss(animated: true)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}
