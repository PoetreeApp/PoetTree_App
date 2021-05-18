//
//  UserDetailWritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/17.
//

import UIKit
import Alamofire
import SwiftyJSON
//댓글

class UserDetailWritingViewController: UIViewController {
    
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentCountLabel: UIButton!
    
    var userWriting: UserWriting?
    var hashtags: String?
    var comments: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHashTag(id: userWriting?.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("vwacalled")
        setUI()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SEGUE_ID.toUserWritingCorrection {
            guard let vc = segue.destination as? UserWritingCorrectionViewController else {return}
            
            vc.userWriting = self.userWriting
            vc.hashtags = self.hashtags
            vc.changeUI = { writing in
                
                self.userWriting?.title = writing.title
                self.userWriting?.content = writing.content
                self.hashtags = "\(writing.hashtags[0]) \(writing.hashtags[1])"
                
                self.hashtagLabel.text = self.hashtags
                
            }
        }
        
        if segue.identifier == K.SEGUE_ID.toUserComment {
            guard let vc = segue.destination as? UserWritingCommentViewController,
                  let id = self.userWriting?.id else {return}
            
            vc.writingId = id
            vc.comments = comments
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
                    self.hashtagLabel.text = hashtags
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

    
    fileprivate func setUI(){
        
        guard let userWriting = self.userWriting else {return}
        
        self.selectedImageView.image = userWriting.image
        self.titleLabel.text = userWriting.title
        self.contentLabel.text = userWriting.content
        self.userLabel.text = userWriting.name
        self.hashtagLabel.text = hashtags
        getLikers(id: userWriting.id) { likers in
            let isLike = likers.contains { liker in
                if liker.name == userWriting.name {
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
                   let commenter = comment["commenterName"].string else {return Comment(id: 1, comment: "2", commenter: "4")}
                return Comment(id: id, comment: commentContent, commenter: commenter)
            }
            
            self.commentCountLabel.setTitle("댓글 \(self.comments?.count ?? 0)개 모두 보기", for: .normal)
        }
        
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        
        guard let id = self.userWriting?.id else {return}
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            print("삭제 성공")
            self.navigationController?.popViewController(animated: true)
            
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
