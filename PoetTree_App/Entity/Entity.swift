//
//  Entity.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/07/06.
//

import Foundation

struct WritingEntity: Codable {
    
    let id: Int
    let title: String
    let content: String
    let views: Int
    let createdAt: String
    let updatedAt: String
    let UserEmail: String
    let SourceId: Int
    let name: String
    let hashtags: String
    let likes: Int
    let imageURL: String
    
}
