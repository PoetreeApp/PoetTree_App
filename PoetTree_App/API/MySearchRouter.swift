//
//  MySearchRouter.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/07/03.
//

import Foundation
import Alamofire
//최종 목표 -> 서치하는 메소드들을 dry하게 처리하는 것. 일단 writing search부터하려고 함
enum MySearchRouter: URLRequestConvertible {
    case searchWriting
    
    var baseURL: URL {
        return URL(string: K.API.BASE_URL)!
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .searchWriting:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .searchWriting: return "posts"
        }
    }
    
    //실제 호출되는 부분
    func asURLRequest() throws -> URLRequest {
        
        print("MySearchRouter - asURLRequest() called")
        
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        
        return request
    }
}
