//
//  NetworkManager.swift
//  NetworkDemo
//
//  Created by Mint on 2022/7/28.
//

import Foundation
import Alamofire

typealias NetworkRequestResult = Result<Data,Error>
typealias NetworkRequestCompletion = (NetworkRequestResult) -> Void
//路径前面的部分
let networkAPIBaseURL =  "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/"

class NetworkManger {
    //单例模式，外部能够使用这个变量
    static let shared = NetworkManger()
    var commonHeaders: HTTPHeaders {
        ["user_id": "123", "token": "xxxxx"]
    }
    
    private init() {
        
    }
    @discardableResult
    //用alamofire向url发送请求，默认情况下，使用httpget方法发送请求，设置请求参数，设置header信息，设置超时时间，获取响应数据，判断请求是否成功
    func requestGet(path: String, parameters: Parameters?, completion: @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(networkAPIBaseURL + path, parameters: parameters, headers: ["user_id": "123"], requestModifier: {
            //闭包就是urlrequest,设置超时时间
            $0.timeoutInterval = 15
        })
        .responseData { response in
            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(self.handleError(error))
            }
        }
    }
    
    @discardableResult
    //post请求需要指明请求方法
    //parameter一般采用json数据与服务端进行交互，所以需要将数据转换为json数据
    func requestPost(path: String, parameters: Parameters?, completion: @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(networkAPIBaseURL + path, method: .post, parameters: parameters,encoding: JSONEncoding.prettyPrinted, headers: ["user_id": "123"], requestModifier: {
            //闭包就是urlrequest,设置超时时间
            $0.timeoutInterval = 15
        })
        .responseData { response in
            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(self.handleError(error))
            }
        }
    }
    
    private func handleError(_ error: AFError) -> NetworkRequestResult {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "网络连接有问题～"
                let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
                return .failure(currentError)
            }
        }
        return .failure(error)
    }

}
