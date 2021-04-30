//
//  WritingService.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/06.
//

import Foundation
import Alamofire
import SwiftyJSON

class WritingService {
    
    static let shared = WritingService()
    
    var writings: [WritingGet]!
    
    private init(){
        
        AF.request(K.API.WRITING_GET_POST, method: .get).responseJSON { response in
        
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
              
                //writing을 받아와서 초기화함

                for (index, json) in json {
                    
                    print(json["views"].int!)
                    
                    if let title = json["title"].string,
                       let content = json["content"].string,
                       let views = json["views"].int,
                       let likes = json["likes"].int,
                       let hashtags = json["hashtags"].string,
                       let id = json["id"].int,
                       let email = json["UserEmail"].string{
                        
                        self.writings.append(WritingGet(id: id,title: title, content: content, views: views, likes: likes, hashtags: hashtags, userEmail: email))
                        print(self.writings)
                    }
                    
                }

            case .failure(let error):
                print(error)
            }
            
            //제이슨 받은 것을 바꿔서 라이팅에 넣음

        }
        
        
    }
    
}
