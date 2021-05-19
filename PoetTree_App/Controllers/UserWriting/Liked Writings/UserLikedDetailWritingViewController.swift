//
//  UserLikedDetailWritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserLikedDetailWritingViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var hashtagsLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var userWriting: UserWriting?
    var hashtags: String?
    var comments: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHashTag(id: userWriting?.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SEGUE_ID.toLikePoemComment {
            guard let vc = segue.destination as? UserLikedWritingCommentViewController,
                  let id = self.userWriting?.id else {return}
            
            vc.writingId = id
            vc.comments = comments
        }
    }
    
    fileprivate func setupUI(){
        
        guard let writing = self.userWriting,
              let user = GoogleLogInViewController.user else {return}
        
        imageView.image = writing.image
        titleLabel.text = writing.title
        userLabel.text = writing.name
        contentLabel.text = writing.content
        self.hashtagsLabel.text = hashtags
        getLikers(id: writing.id) { likers in
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
        
        getComment { comments in
            
            self.comments = comments.map{ comment in
                guard let id = comment["id"].int,
                   let commentContent = comment["comment"].string,
                   let commenter = comment["commenterName"].string,
                   let email = comment["commenter"].string else {return Comment(id: 1, comment: "2", commenter: "4", commenterEmail: "")}
                
                return Comment(id: id, comment: commentContent, commenter: commenter, commenterEmail: email)
            }
            
            self.commentBtn.setTitle("댓글 \(self.comments?.count ?? 0)개 모두 보기", for: .normal)
        }
    }
    
    fileprivate func setHashTag(id: Int?){
        
        guard let id = id else {return}
        
        AF.request(K.API.WRITING_GET_POST + "\(id)", method: .get).responseJSON { [weak self] response in
            
            guard let self = self else {return}
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let hashtags = json["hashtags"].string {
                    
                    self.hashtags = hashtags
                    self.hashtagsLabel.text = hashtags
                }
            
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    fileprivate func getLikers(id: Int, completion: @escaping ([Liker]) -> Void){
        
        AF.request(K.API.LIKE_POST + "\(id)/likers", method: .get).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var likers: [Liker] = []
                
                for (index, json) in json {
                    guard let likerName = json["name"].string else {return}
                    let liker = Liker(name: likerName)
                    likers.append(liker)
                }
                DispatchQueue.main.async {
                    completion(likers)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func getComment(completion: @escaping ([JSON]) -> Void){
        guard let id = self.userWriting?.id else {return}
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
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        guard let id = self.userWriting?.id else {return}
        
        AF.request(K.API.LIKE_POST + "\(id)/like", method: .post, interceptor: RequestInterceptor()).response {
            response in
            debugPrint(response)
        }
        
    }
}
