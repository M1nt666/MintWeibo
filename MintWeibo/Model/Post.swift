//
//  Post.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/20.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct PostList: Codable {
    var list: [Post]
}


struct Post: Codable, Identifiable {
    let id: Int
    let avatar: String
    let vip: Bool
    let name: String
    let date: String
    var isFollowed: Bool
    
    let text: String
    let images: [String]
    
    var commentCount: Int
    var likeCount: Int
    var isLiked: Bool
    
    var avatarImage: WebImage {
        loadImage(name: avatar)
    }
    
    var commentCountText: String {
        if commentCount <= 0 {
            return "评论"
        }
        if commentCount < 1000 {
            return "\(commentCount)"
        }
        return String(format: "%.1fk", Double(commentCount) / 1000)
    }
    
    var likeCountText : String {
        if likeCount <= 0 {
            return "点赞"
        }
        if likeCount < 1000 {
            return "\(likeCount)"
        }
        return String(format: "%.1fk", Double(likeCount) / 1000)
    }
}
extension Post: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

func loadPostListData(_ fileName: String) -> PostList {
    //通过文件名获取url
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Can't find \(fileName) in main bundle")
    }
    //通过url解析数据
    guard let data = try? Data(contentsOf: url) else {
        fatalError("There is no content in the \(url)")
    }
    //将data解析为对应的postlist文件类型
    let decoder = JSONDecoder()
    
    guard let list = try? decoder.decode(PostList.self, from: data) else {
        fatalError("Can't decode the data")
    }
    return list
}

func loadImage(name: String) -> WebImage {
    WebImage(url: URL(string: networkAPIBaseURL + name))
        .placeholder {
            Color.gray
        }
}
