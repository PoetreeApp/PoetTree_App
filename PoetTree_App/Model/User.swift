//
//  User.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/19.
//

import UIKit
import Alamofire
import SwiftyJSON

struct UserPhoto: Equatable {
    let email: String
    let image: UIImage
    
}

class UserPhotoManager {
    static let shared = UserPhotoManager()
    
    public static var userPhotos = [UserPhoto]()
    
    static func retrieveUser(){
        
        AF.request(K.API.USER_LIST, method: .get).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                let jsonArr = JSON(value)
                let userArr = jsonArr["data"].arrayValue
                
                var users: [UserPhoto] = []
                
                for user in userArr {
                    
                    guard let email = user["email"].string,
                          let imageUrl = user["image"].string else {return}
                    
                    let data = try! Data(contentsOf: URL(string: imageUrl)!)
                    let image = UIImage(data: data)
                    
                    let user = UserPhoto(email: email, image: image!)
                    
                    users.append(user)
                }
                
                UserPhotoManager.userPhotos = users
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
//
//
//class UserListViewModel {
//    
//    private let manager = UserPhotoManager.shared
//    
//    var users: [UserPhoto] {
//        return manager.userPhotos
//    }
//    
//    func retrieveUser(){
//        manager.retrieveUser(completion: <#([UserPhoto]) -> Void#>)
//    }
//}
