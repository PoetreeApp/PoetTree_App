//
//  UserModel.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/04.
//

import Foundation

struct User: Codable{
    
    let email: String
    let name: String
    let provider: String
    let image: String
}
