//
//  PostCell.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/19.
//

import SwiftUI

struct PostCell: View {
    
    let post: Post
    
    @EnvironmentObject var userData: UserData
    var bindingPost: Post {
        userData.post(forId: post.id)!
    }
    
    @State var presentComment = false
    
    var body: some View {
        var post = bindingPost
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                post.avatarImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        PostVIPBadge(vip: post.vip)
                            .offset(x: 15, y: 15)
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.name)
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 242/255, green: 99/255, blue: 4/255))
                    Text(post.date)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
                
                Spacer()
                
                if !post.isFollowed {
                    Button(action: {
                        post.isFollowed = true
                        userData.update(post)
                    }, label: {
                        Text("关注")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                            .frame(width: 50, height: 26, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(Color.orange, lineWidth: 1)
                            )
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            Text(post.text)
                .font(.system(size: 17))
            
            if !post.images.isEmpty {
                PostImageCell(image: post.images, width: UIScreen.main.bounds.width - 30)
            }
            
            Divider()
            HStack(spacing: 5){
                Spacer()
                PostCellToolbarButton(image: post.isLiked ? "heart.fill" : "heart",
                                      text: post.likeCountText,
                                      color: post.isLiked ? .red : .black)
                {
                    if post.isLiked {
                        post.isLiked = false
                        post.likeCount -= 1
                    } else {
                        post.isLiked = true
                        post.likeCount += 1
                    }
                    userData.update(post)
                }
                Spacer()
                PostCellToolbarButton(image: "message", text: post.commentCountText, color: .black) {
                    presentComment = true
                }
                .sheet(isPresented: $presentComment,content: {
                    CommentInputView(post: post).environmentObject(userData)
                })
                Spacer()
            }
            
            Rectangle()
                .padding(.horizontal, -15)
                .frame(height: 10)
                .foregroundColor(Color(red: 235/255, green: 235/255, blue: 235/255))
        }
        .padding(.horizontal, 15)
        .padding(.top, 15)
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData.testData
        PostCell(post: userData.recommendPostList.list[1]).environmentObject(userData)
    }
}
