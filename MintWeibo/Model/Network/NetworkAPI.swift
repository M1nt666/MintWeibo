//
//  NetworkAPI.swift
//  NetworkDemo
//
//  Created by Mint on 2022/7/31.
//

import Foundation

class NetworkAPI {
    static func recommendPostList(completion: @escaping (Result<PostList, Error>) -> Void) {
        NetworkManger.shared.requestGet(path: "PostListData_recommend_1.json", parameters: nil) { result in
            switch result {
            case let .success(data):
                //明确返回值类型
                let parseResult: Result<PostList,Error> = parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    static func hotPostList(completion: @escaping (Result<PostList, Error>) -> Void) {
        NetworkManger.shared.requestGet(path: "PostListData_hot_1.json", parameters: nil) { result in
            switch result {
            case let .success(data):
                //明确返回值类型
                let parseResult: Result<PostList,Error> = parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func createPost(text: String,completion: @escaping(Result<Post,Error>) -> Void) {
        NetworkManger.shared.requestPost(path: "create post", parameters: ["text": text]) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<Post, Error> = parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private static func parseData<T: Decodable>(_ data: Data) -> Result<T, Error> {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            //定义常量，确定错误分类（错误来源什么地方）,错误码
            let error = NSError(domain: "NetworkAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can't parse data"])
            return .failure(error)
        }
        return .success(decodedData)
    }
}
