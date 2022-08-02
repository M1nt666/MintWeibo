//
//  UserData.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/21.
//

import Foundation
import Combine

class UserData: ObservableObject {
    @Published var recommendPostList: PostList = PostList(list: [])
    @Published var hotPostList: PostList = PostList(list: [])
    @Published var isRefreshing = false
    @Published var isLoadingMore = false
    @Published var loadingError: Error?
    @Published var reloadData = false
    
    private var recommendPostDic: [Int : Int] = [:]//微博的id : 这条微博在数组中的序号
    private var hotPostDic: [Int : Int] = [:]
   
}

enum PostListCategory {
    case recommend
    case hot
}

extension UserData {
    //建立本地数据，用于预览界面，闭包加小括号为执行该闭包，然后将值赋予给该变量
    static let testData: UserData = {
        let data = UserData()
        data.handleRefreshPostList(loadPostListData("PostListData_recommend_1.json"), for: .recommend)
        data.handleRefreshPostList(loadPostListData("PostListData_hot_1.json"), for: .hot)
        return data
    }()
    
    //是否显示加载错误
    var showLoadingError: Bool {
        loadingError != nil
    }
    var loadingErrorText: String {
        loadingError?.localizedDescription ?? " "
    }
    
    func postList(for category: PostListCategory) -> PostList {
        switch category {
        case .recommend:
            return recommendPostList
        case .hot:
            return hotPostList
        }
    }
    
    //通过字典找到对应的微博，微博id找到他在微博数组中的位置
    func post(forId id: Int) -> Post? {
        if let index = recommendPostDic[id] {
            return recommendPostList.list[index]
        }
        if let index = hotPostDic[id] {
            return hotPostList.list[index]
        }
        return nil
    }
    
    //添加启动时加载网络数据
    func loadPostListIfNeeded(for category: PostListCategory) {
        if postList(for: category).list.isEmpty {
            refreshPostList(for: category)
        }
    }
    
    //更新微博
    func update(_ post: Post) {
        if let index = recommendPostDic[post.id] {
            recommendPostList.list[index] = post
        }
        if let index = hotPostDic[post.id] {
            hotPostList.list[index] = post
        }
    }
    
    //下拉刷新
    func refreshPostList(for category: PostListCategory) {
        let completion: (Result<PostList,Error>) -> Void = { result in
            switch result {
            case let .success(list): self.handleRefreshPostList(list, for: category)
            case let .failure(error): self.handleLoadingError(error)
            }
            //加载完刷新之后，停止加载圈的转动
            self.isRefreshing = false
        }
        switch category {
        case .recommend:
            NetworkAPI.recommendPostList(completion: completion)
        case .hot:
            NetworkAPI.hotPostList(completion: completion)
        }
    }
    
    //处理下拉刷新得到的数据
    private func handleRefreshPostList(_ list: PostList, for category: PostListCategory) {
        var tempList: [Post] = []
        var tempDic: [Int : Int] = [:]
        //获取list中的对应post及对应序号,循环数组完成以上两个局部变量的填充
        for (index, post) in list.list.enumerated() {
            //确定当前post是否存在，若存在说明该条post重复，可直接进行下一步
            if tempDic[post.id] != nil {
                continue
            }
            tempList.append(post)
            tempDic[post.id] = index
            //以服务端更新本地数据
            update(post)
        }
        switch category {
        case .recommend:
            recommendPostList.list = tempList
            recommendPostDic = tempDic
        case .hot:
            hotPostList.list = tempList
            hotPostDic = tempDic
        }
        reloadData = true 
    }
    
    //处理错误
    private func handleLoadingError(_ error: Error) {
        loadingError = error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadingError = nil
        }
    }
    
    //上拉加载更多
    func loadMorePostList(for category: PostListCategory) {
        if isLoadingMore || postList(for: category).list.count >= 10 {
            return
        }
        isLoadingMore = true
        
        let completion: (Result<PostList,Error>) -> Void = { result in
            switch result {
            case let .success(list): self.handleLoadMorePostList(list, for: category)
            case let .failure(error): self.handleLoadingError(error)
            }
            self.isLoadingMore = false
        }
        
        switch category {
        case .recommend:
            NetworkAPI.hotPostList(completion: completion)
        case .hot:
            NetworkAPI.recommendPostList(completion: completion)
        }
    }
    
    private func handleLoadMorePostList(_ list: PostList, for category: PostListCategory) {
        switch category {
        case .recommend:
            //遍历整个数组,取出其中的元素
            for post in list.list {
                update(post)
                //检查是否重复
                if recommendPostDic[post.id] != nil {
                    continue
                }
                recommendPostList.list.append(post)
                recommendPostDic[post.id] = recommendPostList.list.count - 1
            }
        case .hot:
            //遍历整个数组,取出其中的元素
            for post in list.list {
                update(post)
                //检查是否重复
                if hotPostDic[post.id] != nil {
                    continue
                }
                hotPostList.list.append(post)
                hotPostDic[post.id] = hotPostList.list.count - 1
            }
        }
    }
}
