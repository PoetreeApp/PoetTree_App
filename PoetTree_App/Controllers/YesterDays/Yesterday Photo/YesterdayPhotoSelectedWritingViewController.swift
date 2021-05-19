//
//  YesterdayPhotoSelectedWritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class YesterdayPhotoSelectedWritingViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var hashtagsLabel: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var commentCountBtn: UIButton!
    @IBOutlet weak var correctionBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var reactionStackView: UIStackView!
    
    var writing: WritingGet?
    var comments: [Comment]?
    var likers: [Liker]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoCorrection" {
            guard let vc = segue.destination as? YesterdayPhotoCorrectionViewController else  { return }
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
    }
    
    fileprivate func setUpUI(){
        
        guard let writing = writing else {return}
        
        titleLabel.text = writing.title
        contentLabel.text = writing.content
        userLabel.text = writing.userName
        imageView.image = writing.image
        hashtagsLabel.text = writing.hashtags
        getComment { comments in
            
            self.comments = comments.map{ comment in
                guard let id = comment["id"].int,
                   let commentContent = comment["comment"].string,
                   let commenter = comment["commenterName"].string else {return Comment(id: 1, comment: "2", commenter: "4")}
                return Comment(id: id, comment: commentContent, commenter: commenter)
            }
            
            self.commentCountBtn.setTitle("댓글 \(self.comments?.count ?? 0)개 모두 보기", for: .normal)
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
                self.heartBtn.isSelected = true
            }
        }
        
        if let user = GoogleLogInViewController.user {
          
            reactionStackView.isHidden = false
          
            if GoogleLogInViewController.user?.profile.email == writing.userEmail {
                correctionBtn.isHidden = false
                deleteBtn.isHidden = false
            } else {
                correctionBtn.isHidden = true
                deleteBtn.isHidden = true

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
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        guard let id = writing?.id else {return}
        
        AF.request(K.API.LIKE_POST + "\(id)/like", method: .post, interceptor: RequestInterceptor()).response {
            response in
            debugPrint(response)
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
}
