//
//  PostDetailView.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/21.
//

import SwiftUI
import BBSwiftUIKit

struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        BBTableView(0...10) { i in
            if i == 0 {
                PostCell(post: post)
            } else {
                HStack {
                    Text("评论\(i)")
                        .padding()
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("微博详情", displayMode: .inline)
    }
    
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData.testData
        PostDetailView(post: userData.recommendPostList.list[0]).environmentObject(userData)
    }
}
