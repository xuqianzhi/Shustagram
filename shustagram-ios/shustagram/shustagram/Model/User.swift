//
//  User.swift
//  shustagram
//
//  Created by 徐乾智 on 7/25/21.
//

import Foundation

struct User: Decodable {
    let id: String
    let fullName: String
    var isFollowing: Bool?
    
    var profileImageUrl: String?
    
    var following, followers: [User]?
    
    var posts: [Post]?
    
    var isEditable: Bool?
}
