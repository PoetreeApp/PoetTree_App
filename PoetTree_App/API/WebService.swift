//
//  WebService.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/12.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

struct Resource<T: Codable> {
    let url: URL
}

class Webservice {
    
    func load<T>(resource: Resource<T>, completion: @escaping( Result<T, NetworkError>)-> Void) {
        
        AF.request(resource.url, method: .get).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                completion(.success(value as! T))
            case .failure(let error):
                completion(.failure(.decodingError))
                print(error.localizedDescription)
            }
        }
    }
}
