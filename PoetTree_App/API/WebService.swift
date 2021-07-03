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

//
//if let title = titleTextField.text,
//   let content = contentTextField.text,
//   let email = GoogleLogInViewController.user.profile.email,
//   let hashtags = keyWord {
//
//    let writing = Writing(title: title, content: content, email: email, hashtags: hashtags)
//
//
//    //소스 아이디를 같이 보냄
//
//    let parameter: [String : Any] =
//        [ "title" : writing.title,
//          "content" : writing.content,
//          "email" : writing.email,
//          "hashtags": "\(writing.hashtags[0]) \(writing.hashtags[1])"
//        ]
//
//    guard let sourceID = self.sourceID else {return}
//
//    AF.request(K.API.WRITING_GET_POST+"?SourceId=\(sourceID)", method: .post, parameters: parameter, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
//        response in
//
//        debugPrint(response)
//        self.navigationController?.popViewController(animated: true)
