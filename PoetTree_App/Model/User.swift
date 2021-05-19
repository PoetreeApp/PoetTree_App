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
    
    var userPhotos = [UserPhoto]()
    
    func retrieveUser(){
        
    }
    
}
