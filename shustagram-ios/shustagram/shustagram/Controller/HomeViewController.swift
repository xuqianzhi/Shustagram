//
//  HomeViewController.swift
//  shustagram
//
//  Created by 徐乾智 on 7/21/21.
//

import UIKit
import WebKit
import Alamofire
import SDWebImage
import JGProgressHUD
import LBTATools

extension HomeViewController: PostDelegate {
    func showLikes(post: Post) {
        let likesController = LikeViewController(postId: post.id)
        navigationController?.pushViewController(likesController, animated: true)
    }
    
    func handleLike(post: Post) {
        collectionView.isUserInteractionEnabled = false
        let hasLiked = post.hasLiked == true
                
        let string = hasLiked ? "dislike" : "like"
        let url = "\(Service.shared.baseUrl)/\(string)/\(post.id)"
        // for a more interactive UI, update UI before response received
        guard let indexOfPost = self.items.firstIndex(where: {$0.id == post.id}) else { return }
        self.items[indexOfPost].hasLiked?.toggle()
        self.items[indexOfPost].numLikes += hasLiked ? -1 : 1
        let indexPath = IndexPath(item: indexOfPost, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { (res) in
                self.collectionView.isUserInteractionEnabled = true
                switch res.result {
                case .success(_):
                    print("successfully \(string) the post")
                case .failure(let err):
                    print("fail to \(string) the post: ", err)
                    return
                }
        }
    }
    
    func showOptions(post: Post) {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(.init(title: "Show profile", style: .default, handler: { (_) in
            let profilevc = ProfileViewController(userId: post.user.id)
            self.navigationController?.pushViewController(profilevc, animated: true)
        }))
        let unfollowAlertController = UIAlertController(title: "Unfollow the user?", message: nil, preferredStyle: .actionSheet)
        unfollowAlertController.addAction(.init(title: "Unfollow", style: .destructive, handler: { (_) in
            print("Trying to unfollow user")
            let userId = post.user.id
            let url = "\(Service.shared.baseUrl)/unfollow/\(userId)"
            AF.request(url, method: .post)
                .validate(statusCode: 200..<300)
                .response(completionHandler: { res in
                    switch res.result {
                    case .success(_):
                        print("successfully performed unfollow")
                        self.fetchPosts()
                    case .failure(let err):
                        print("Failed to perform unfollow:", err)
                        return
                    }
                })
        }))
        unfollowAlertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(.init(title: "Unfollow", style: .destructive, handler: { (_) in
            alertController.dismiss(animated: true)
            self.present(unfollowAlertController, animated: true)
        }))
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }
    
    func showComments(post: Post) {
        let postDetailsController = PostDetailsController(postId: post.id)
        navigationController?.pushViewController(postDetailsController, animated: true)
    }
}

class HomeViewController: LBTAListController<UserPostCell, Post>, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .black

        fetchPosts()
        navigationItem.rightBarButtonItems = [
            .init(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(handleSearch))
        ]

        navigationItem.leftBarButtonItem = .init(title: "Log In", style: .plain, target: self, action: #selector(handleLogin))

        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        self.collectionView.refreshControl = rc
        // Do any additional setup after loading the view.
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        dismiss(animated: true) {
            let createPostController = CreatePostViewController(selectedImage: image)
            createPostController.homeController = self
            self.present(createPostController, animated: true)
        }
    }

    @objc func handleSearch() {
        let navController = UINavigationController(rootViewController: UsersSearchViewController())
        present(navController, animated: true)
    }

    @objc fileprivate func createPost() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    @objc fileprivate func handleLogin() {
        let vc = LoginViewController()
        vc.homeController = self
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
    }

    @objc func fetchPosts() {
        Service.shared.fetchPosts { (res) in
            self.collectionView.refreshControl?.endRefreshing()
            switch res {
            case .failure(let err):
                print("Failed to fetch posts:", err)
            case .success(let posts):
                self.items = posts
                self.collectionView.reloadData()
            }
        }
    }
    
    

}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)

        return .init(width: view.frame.width, height: height)
    }
}
