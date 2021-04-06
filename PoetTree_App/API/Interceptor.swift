//
//  Interceptor.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/04.
//

import Foundation
import Alamofire


final class RequestInterceptor: Alamofire.RequestInterceptor {

    
    private let storage: String
    
    init(){
        let userDefaults = UserDefaults.standard
        guard let token = userDefaults.string(forKey: "token") else {
            fatalError("token errer")
        }
        self.storage = token
    }


    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("\(storage) adapt token")
        
        var urlRequest = urlRequest
        
//        urlRequest.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")

        /// Set the Authorization header value using the access token.
        urlRequest.setValue("Bearer " + storage, forHTTPHeaderField: "Authorization")

        
        completion(.success(urlRequest))
    }

   
}
