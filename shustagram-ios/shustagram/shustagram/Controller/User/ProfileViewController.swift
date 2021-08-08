//
//  ProfileViewController.swift
//  shustagram
//
//  Created by 徐乾智 on 7/25/21.
//

import LBTATools
import Alamofire

extension ProfileViewController: PostDelegate {
    func showLikes(post: Post) {
        print("not yet implemented")
    }
    
    func showComments(post: Post) {
        let postDetailsController = PostDetailsController(postId: post.id)
        navigationController?.pushViewController(postDetailsController, animated: true)
    }
    
    func showOptions(post: Post) {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Delete post", style: .destructive, handler: { (_) in
            Service.shared.deletePost(postId: post.id) { res in
                switch res.result {
                case .success(_):
                    print("post deletion was successful")
                    guard let index = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                    self.items.remove(at: index)
                    self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                case .failure(let err):
                    print("Failed to delete post with error: ", err)
                    return
                }
            }
        }))
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }
    
    func handleLike(post: Post) {
        collectionView.isUserInteractionEnabled = false
        let hasLiked = post.hasLiked == true
                
        let string = hasLiked ? "dislike" : "like"
        let url = "\(Service.shared.baseUrl)/\(string)/\(post.id)"
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { (res) in
                self.collectionView.isUserInteractionEnabled = true
                switch res.result {
                case .success(_):
                    print("successfully \(string) the post")
                    guard let indexOfPost = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                    self.items[indexOfPost].hasLiked?.toggle()
                    self.items[indexOfPost].numLikes += hasLiked ? -1 : 1
                    let indexPath = IndexPath(item: indexOfPost, section: 0)
                    self.collectionView.reloadItems(at: [indexPath])
                case .failure(let err):
                    print("fail to \(string) the post: ", err)
                    return
                }
        }
    }
    
    
}

class ProfileViewController: LBTAListHeaderController<UserPostCell, Post, ProfileHeader> {

    let userId: String
    
    var user: User?
    
    var canDelete: Bool = true
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserProfile()
        
        setupActivityIndicatorView()
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchUserProfile), for: .valueChanged)
        self.collectionView.refreshControl = rc
        
        let isShowingPersonalProfile = self.userId.isEmpty ? true : false
        if (!isShowingPersonalProfile) {
            self.canDelete = false
        }
    }
    
    override func setupHeader(_ header: ProfileHeader) {
        super.setupHeader(header)
        
        if user == nil { return }
        
        header.user = self.user
        header.profileController = self
    }
    
    func handleFollowUnfollow() {
        guard let user = user else { return }
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollow" : "follow")/\(user.id)"
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response(completionHandler: { res in
                switch res.result {
                case .success(_):
                    print("successfully performed follow/unfollow")
                    self.user?.isFollowing = !isFollowing
                    self.collectionView.reloadData()
                case .failure(let err):
                    print("Failed to perform follow/unfollow:", err)
                    return
                }
            })
    }
    
    @objc func fetchUserProfile() {
        let currentUserProfileUrl = "\(Service.shared.baseUrl)/profile" // show current loggedIn user profile
        let publicProfileUrl = "\(Service.shared.baseUrl)/user/\(userId)" // show clicked user profile
        
        let isShowingPersonalProfile = self.userId.isEmpty ? true : false
        let url = isShowingPersonalProfile ? currentUserProfileUrl : publicProfileUrl
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                self.collectionView.refreshControl?.endRefreshing()
                switch dataResp.result {
                case .success(_):
                    self.activityIndicatorView.stopAnimating()
                    let data = dataResp.data ?? Data()
                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        self.user = user
                        
                        self.user?.isEditable = self.userId.isEmpty
                        
                        self.items = user.posts ?? []
                        self.collectionView.reloadData()
                    } catch {
                        print("Error when decoding user", error)
                    }
                case .failure(let err):
                    print("Failed to fetch user profile:", err)
                    return
                }
        }
    }
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.startAnimating()
        aiv.color = .darkGray
        return aiv
    }()
    
    fileprivate func setupActivityIndicatorView() {
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// for UI layout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if user == nil {
            return .zero
        }
        
        return .init(width: 0, height: 300)
    }
}
