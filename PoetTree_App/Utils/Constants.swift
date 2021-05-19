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
        static let toUserDetailWriting = "toUserDetailWriting"
        static let toUserWritingCorrection = "toUserWritingCorrection"
        static let toUserComment = "toUserComment"
        static let toDetailLikedWriting = "toDetailLikedWriting"
        static let toLikePoemComment = "toLikePoemComment"
        static let toPhotoWriting = "toPhotoWriting"
        
    }
    struct API {
        static let BASE_URL = "http://54.180.34.121:8080/"
        static let USER_SIGNIN: String = BASE_URL + "users/signIn"
        static let WRITING_GET_POST: String = BASE_URL + "posts/"
        static let PHOTOS_GET: String = BASE_URL + "sources"
        static let LIKE_POST: String = BASE_URL + "posts/"
        static let USER_WRITINGS: String = BASE_URL + "users/mypage/myposts/"
        static let COMMENT_DELETE: String = BASE_URL + "posts/"
        static let LIKED_WRITINGS: String = BASE_URL + "users/mypage/getLikedPosts"
        static let PAST_IMAGES: String = BASE_URL + "sources/previousImages"
        static let PHOTO_WRITING: String = BASE_URL + "posts/sourcePosts/"
        
    }
    struct TABLE_VIEW_CELL_ID {
        static let postsCell = "PostsCell"
        static let commentCell = "CommentCell"
    }
    
    struct ColorName {
        static let pageControlSelectedColor = "pageControlSelectedColor"
        static let pageControlNonSelectedColor = "pageControlNonSelectedColor"
    }
}
