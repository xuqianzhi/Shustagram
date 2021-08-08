//
//  Comment.swift
//  shustagram
//
//  Created by 徐乾智 on 7/27/21.
//

import Foundation


struct Comment: Decodable {
    let text: String
    let user: User
    let fromNow: String
}
