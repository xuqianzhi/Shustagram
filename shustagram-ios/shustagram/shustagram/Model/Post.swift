//
//  Post.swift
//  shustagram
//
//  Created by 徐乾智 on 7/22/21.
//

import Foundation

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let user: User
    let imageUrl: String
    
    var fromNow: String?
    var comments: [Comment]?
    
    var hasLiked: Bool?
    
    var numLikes: Int
}
