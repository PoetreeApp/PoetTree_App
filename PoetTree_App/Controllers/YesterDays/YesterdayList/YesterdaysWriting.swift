//
//  YesterdaysWriting.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/18.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class YesterdaysWriting: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var correctionButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hashtagsLabel: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var writingImage: UIImageView!
    @IBOutlet weak var reactionStackView: UIStackView!
    
    
    var writing: WritingGet?
    var comments: [Comment]?
    var likers: [Liker]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    fileprivate func setUpUI(){
        
        guard let writing = writing else {return}
        
        titleLabel.text = writing.title
        contentLabel.text = writing.content
        userNameLabel.text = writing.userName
        writingImage.image = writing.image
        hashtagsLabel.text = writing.hashtags
        getComment { comments in
            
            self.comments = comments.map{ comment in
                guard let id = comment["id"].int,
                   let commentContent = comment["comment"].string,
                   let commenter = comment["commenterName"].string else {return Comment(id: 1, comment: "2", commenter: "4")}
                return Comment(id: id, comment: commentContent, commenter: commenter)
            }
            
            self.commentCountButton.setTitle("댓글 \(self.comments?.count ?? 0)개 모두 보기", for: .normal)
        }
        
        getLikers { likers in
            
            guard let user = GoogleLogInViewController.user else {return}
            
            self.likers = likers.map{ liker in
                guard let name = liker["name"].string else {return Liker(name: "kim")}
                return Liker(name: name)
            }
            guard let likers = self.likers else {return}
            
           let isLike = likers.contains { liker in
                if liker.name == user.profile.name {
                    return true
                } else {
                    return false
                }
            }
            if isLike {
                self.likeBtn.isSelected = true
            }
        }
        
        if let user = GoogleLogInViewController.user {
          
            reactionStackView.isHidden = false
          
            if GoogleLogInViewController.user?.profile.email == writing.userEmail {
                correctionButton.isHidden = false
                deleteButton.isHidden = false
            } else {
                correctionButton.isHidden = true
                deleteButton.isHidden = true
//                reactStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            }
        }
    }
    
    fileprivate func getComment(completion: @escaping ([JSON]) -> Void){
        guard let id = self.writing?.id else {return}
        AF.request(K.API.WRITING_GET_POST + "\(id)", method: .get).responseJSON {
            post in
            
            switch post.result {
            case .success(let value):
                let json = JSON(value)
                let comments = json["comments"].arrayValue
                
                DispatchQueue.main.async {
                    completion(comments)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func getLikers(completion: @escaping ([JSON]) -> Void){
        guard let id = self.writing?.id else {return}
        AF.request(K.API.WRITING_GET_POST + "\(id)", method: .get).responseJSON {
            post in
            
            switch post.result {
            case .success(let value):
                let json = JSON(value)
                let likers = json["likers"].arrayValue
                
                DispatchQueue.main.async {
                    completion(likers)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SEGUE_ID.toCorrectionDetail {
            guard let vc = segue.destination as? YesterDayCorrectionViewController else  { return }
            guard let title = titleLabel.text,
                  let content = contentLabel.text else {return}
            self.writing?.title = title
            self.writing?.content = content
            guard let writing = self.writing else { return }
            vc.writing = writing
            vc.changeUI = { wrting in
                self.titleLabel.text = wrting.title
                self.contentLabel.text = wrting.content
                self.hashtagsLabel.text = "\(wrting.hashtags[0]) \(wrting.hashtags[1])"
            }
        }
        
        if segue.identifier == K.SEGUE_ID.toComments {
            
            guard let vc = segue.destination as? CommentViewController,
                  let comments = self.comments,
                  let id = self.writing?.id else { return }
            
            vc.comment = comments
            vc.writingId = id
            vc.delegate = self
        }
    }
    
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        
        guard let id = writing?.id else {return}
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            print("삭제 성공")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let id = writing?.id else {return}
        
        AF.request(K.API.LIKE_POST + "\(id)/like", method: .post, interceptor: RequestInterceptor()).response {
            response in
            debugPrint(response)
        }
    }
    
}

extension YesterdaysWriting: AddCommentDelegate {
    func addComment(comments: [Comment]) {
        self.comments = comments
        self.commentCountButton.setTitle("댓글 \(self.comments?.count ?? 0)개 모두 보기", for: .normal)
    }
}


struct Comment: Codable {
    let id: Int
    var comment: String
    var commenter: String
}

struct Liker: Codable {
    let name: String
}
