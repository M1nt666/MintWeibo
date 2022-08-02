//
//  CommentInputView.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/24.
//

import SwiftUI

struct CommentInputView: View {
    let post: Post
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserData
    @State private var text = ""
    @State private var showEmptyTextHUD = false
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        VStack {
            CommentTextView(text: $text, beginEdittingOnAppear: true)
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("取消")
                        .padding()
                })
                
                Spacer()
                
                Button(action: {
                    print(text)
                    if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        showEmptyTextHUD = true
                        //让显示在1.5秒后消失
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showEmptyTextHUD = false
                        }
                        //评论为空不执行后面的代码
                        return
                    }
                    var post = post
                    post.commentCount += 1
                    userData.update(post)

                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Text("发送")
                        .padding()
                })
            }
            .font(.system(size: 18))
        .foregroundColor(.black)
        }
        .overlay {
            Text("评论不能为空")
                .scaleEffect(showEmptyTextHUD ? 1 : 0.5)
                .opacity(showEmptyTextHUD ? 1 : 0)
                .animation(.easeInOut, value: showEmptyTextHUD)
        }
        .padding(.bottom)
    }
}

struct CommentInputView_Previews: PreviewProvider {
    static var previews: some View {
        CommentInputView(post: UserData.testData.recommendPostList.list[0])
    }
}
