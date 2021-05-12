//
//  Constants.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/03/31.
//

import Foundation

struct K {
    struct SEGUE_ID {
        static let toWriting = "toWriting"
        static let toUserWriting = "toUserWriting"
        static let toLogIn = "goToLogIn"
        static let toYesterdayWriting = "toYesterdayWriting"
        static let toCorrectionDetail = "toCorrection"
        static let toComments = "toComment"
    }
    struct API {
        static let BASE_URL = "http://54.180.34.121:8080/"
        static let USER_POST: String = BASE_URL + "users/signIn"
        static let WRITING_GET_POST: String = BASE_URL + "posts/"
        static let PHOTOS_GET: String = BASE_URL + "sources"
        static let LIKE_POST: String = BASE_URL + "posts/"
        
    }
    struct TABLE_VIEW_CELL_ID {
        static let postsCell = "PostsCell"
    }
}
