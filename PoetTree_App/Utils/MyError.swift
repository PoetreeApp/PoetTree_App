//
//  MyError.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/07/03.
//

import Foundation

enum MyError: String, Error {
    case noWriting = "글을 가져올 수 없음"
    case noPhotos = "오늘의 사진이 없음"
}
