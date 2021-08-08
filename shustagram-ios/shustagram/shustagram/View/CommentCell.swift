//
//  CommentCell.swift
//  shustagram
//
//  Created by 徐乾智 on 7/27/21.
//

import LBTATools

class CommentCell: LBTAListCell<Comment> {
    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 15))
    let profileImageView = CircularImageView(width: 44)
    let fromNowLabel = UILabel(text: "Posted 5d ago", textColor: .gray)
    let commentLabel = UILabel(text: "Comment text", font: .systemFont(ofSize: 14), textColor: .black, numberOfLines: 0)
    
    override var item: Comment! {
        didSet {
            commentLabel.text = item.text
            profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? ""))
            fromNowLabel.text = item.fromNow
            usernameLabel.text = item.user.fullName
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        stack(hstack(profileImageView,
                     stack(usernameLabel,
                           fromNowLabel,
                           spacing: 2),
                     UIView(),
                     spacing: 12,
                     alignment: .center),
              commentLabel,
              spacing: 12).withMargins(.allSides(16))
        
        addSeparatorView(leftPadding: 0)
    }
}
