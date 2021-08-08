//
//  UserSearchViewController.swift
//  shustagram
//
//  Created by 徐乾智 on 7/25/21.
//

import LBTATools


class UsersSearchViewController: LBTAListController<UserSearchCell, User> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search"
        
        Service.shared.searchForUsers { (res) in
            switch res {
            case .failure(let err):
                print("Failed to find users:", err)
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
            }
        }
    }
    
    // present user profile page
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = items[indexPath.item]
        let controller = ProfileViewController(userId: user.id)
        navigationController?.pushViewController(controller, animated: true)
    }
} 

extension UsersSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
