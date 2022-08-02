//
//  PostListView.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/20.
//

import SwiftUI
import BBSwiftUIKit

struct PostListView: View {
    
    let category: PostListCategory
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        BBTableView(userData.postList(for: category).list) { post in
            NavigationLink(destination: PostDetailView(post: post), label: {
                PostCell(post: post)
            })
            //link会附带一层button，需要进行button样式的调整
            .buttonStyle(OriginalButtonStyle())
        }
        .bb_setupRefreshControl({ control in
            control.attributedTitle = NSAttributedString(string: "加载中..")
        })
        .bb_pullDownToRefresh(isRefreshing: $userData.isRefreshing) {
            //下拉刷新调用刷新列表方法
            userData.refreshPostList(for: category)
//            userData.loadingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                userData.isRefreshing = false
//                userData.loadingError = nil
            }
        }
        .bb_pullUpToLoadMore(bottomSpace: 30) {
            userData.loadMorePostList(for: category)
//            if userData.isLoadingMore {
//                return
//            }
//            userData.isLoadingMore = true
//            print("Load more")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                userData.isLoadingMore = false
//            }
        }
        .bb_reloadData($userData.reloadData)
        //页面显示时加载网络数据
        .onAppear(perform: {
            userData.loadPostListIfNeeded(for: category)
        })
        .overlay(
            Text(userData.loadingErrorText)
                .bold()
                .frame(width: 200)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .opacity(0.8)
                )
                .scaleEffect(userData.showLoadingError ? 1 : 0.5)
                .animation(.spring(dampingFraction: 0.5),value: userData.showLoadingError)
                .opacity(userData.showLoadingError ? 1 : 0)
                .animation(.easeInOut,value: userData.showLoadingError)
        )
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostListView(category: .recommend)
                .navigationTitle("Title")
                .navigationBarHidden(true)
        }
        .environmentObject(UserData())
    }
}
