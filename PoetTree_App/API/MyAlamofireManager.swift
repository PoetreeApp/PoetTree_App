//
//  MyAlamofireManager.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/07/03.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamofireManager {
    
    static let shared = MyAlamofireManager()
    
    let interceptor = RequestInterceptor()
    
    var session: Session
    
    private init(){
        session = Session(interceptor: interceptor)
    }
    
    func getWritings(completion: @escaping (Result<[WritingGet], MyError>) -> Void) {
        self.session
            .request(MySearchRouter.searchWriting)
            .validate(statusCode: 200..<401)
            .responseJSON { response in
                guard let responseValue = response.value else {return}
                
                let json = JSON(responseValue)
                
                var writings: [WritingGet] = []
                
                for (index, value) in json {
                    if let title = value["title"].string,
                       let content = value["content"].string,
                       let views = value["views"].int,
                       let likes = value["likes"].int,
                       let hashtags = value["hashtags"].string,
                       let id = value["id"].int,
                       let email = value["UserEmail"].string,
                       let userName = value["name"].string,
                       let imageURL = value["imageURL"].string {
                        
                        if let data = try? Data(contentsOf: URL(string: imageURL)!), let image = UIImage(data: data){
                            
                            let writing = WritingGet(id: id, title: title, content: content, views: views, likes: likes, hashtags: hashtags, userEmail: email, userName: userName, image: image)
                            writings.append(writing)
                        }
                    }
                }
                
                if writings.count > 0 {
                    completion(.success(writings))
                } else {
                    completion(.failure(.noWriting))
                }
            }
    }
}
