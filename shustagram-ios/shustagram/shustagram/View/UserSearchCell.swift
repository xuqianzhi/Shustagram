//
//  UserSearchTableViewCell.swift
//  shustagram
//
//  Created by 徐乾智 on 7/25/21.
//


import LBTATools
import Alamofire

extension UsersSearchViewController {
    func didFollow(user: User) {
        guard let index = self.items.firstIndex(where: {$0.id == user.id}) else { return }
        
        let isFollowing = user.isFollowing == true
        let followStr = isFollowing ? "unfollow" : "follow"
        let url = "\(Service.shared.baseUrl)/\(followStr)/\(user.id)"
        
        // for a more interactive UI, update UI before response received
        self.view.isUserInteractionEnabled = false
        self.items[index].isFollowing = !isFollowing
        self.collectionView.reloadItems(at: [[0, index]])
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response(completionHandler: { res in
                self.view.isUserInteractionEnabled = true
                switch res.result {
                case .success(_):
                    print("successfully performed \(followStr)")
                case .failure(let err):
                    print("Failed to perform \(followStr):", err)
                    return
                }
            })
        
    }
}

class UserSearchCell: LBTAListCell<User> {
    
    let nameLabel = UILabel(text: "Full Name", font: .boldSystemFont(ofSize: 16), textColor: .black)
    lazy var followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleFollow))
    
    @objc fileprivate func handleFollow() {
        (parentController as? UsersSearchViewController)?.didFollow(user: item)
    }
    

    // MARK: UI Element
    override var item: User! {
        didSet {
            nameLabel.text = item.fullName
            
            if item.isFollowing == true {
                followButton.backgroundColor = .black
                followButton.setTitleColor(.white, for: .normal)
                followButton.setTitle("Unfollow", for: .normal)
            } else {
                followButton.backgroundColor = .white
                followButton.setTitleColor(.black, for: .normal)
                followButton.setTitle("Follow", for: .normal)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        followButton.layer.cornerRadius = 17
        followButton.layer.borderWidth = 1
        
        hstack(nameLabel,
               UIView(),
               followButton.withWidth(100).withHeight(34),
               alignment: .center)
            .padLeft(24).padRight(24)
        
        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
    }
    
}
