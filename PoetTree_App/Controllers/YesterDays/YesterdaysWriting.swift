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

// 댓글 작업, 좋아요 기능.

class YesterdaysWriting: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var correctionButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var reactStackView: UIStackView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var writingImage: UIImageView!
    
    
    
    var writing: WritingGet?
    var comments: [Comment]?
    //커멘트 따로 받아야함. 받아서 넘겨줌
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        commentTextField.delegate = self
    }
    
    fileprivate func setUpUI(){
        
        guard let writing = writing else {return}
        
        titleLabel.text = writing.title
        contentLabel.text = writing.content
        userNameLabel.text = writing.userName
        writingImage.image = writing.image
        getComment { comments in
            
            self.comments = comments.map{ comment in
                guard let id = comment["id"].int,
                   let commentContent = comment["comment"].string,
                   let commenter = comment["commenterName"].string else {return Comment(id: 1, comment: "2", commenter: "4")}
                return Comment(id: id, comment: commentContent, commenter: commenter)
            }
           
        }
        
        if GoogleLogInViewController.user?.profile.email == writing.userEmail {
            correctionButton.isHidden = false
            deleteButton.isHidden = false
        } else {
            correctionButton.isHidden = true
            deleteButton.isHidden = true
            reactStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
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
            }
        }
        
        if segue.identifier == K.SEGUE_ID.toComments {
            
            guard let vc = segue.destination as? CommentViewController,
                  let comments = self.comments else { return }
            
            vc.comment = comments
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
        
        //사용자 로그인 안했으면 toast 띄우기
        
        AF.request(K.API.LIKE_POST + "\(id)/like", method: .post, interceptor: RequestInterceptor()).response {
            response in
            debugPrint(response)
        }
    }
    
    
    @IBAction func commentPostTapped(_ sender: UIButton) {
        
        guard let comment = commentTextField.text,
              let id = writing?.id
        else {return}
        
        //코멘트 포스트함
        
        let parameter: [String : Any] = [
            "comment" : comment
        ]

        AF.request(K.API.LIKE_POST + "\(id)/comment", method: .post, parameters: parameter, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response {
            response in
            debugPrint(response)
        }
    }
    
}

extension YesterdaysWriting: UITextFieldDelegate {
    
    //타이핑 시작하면 게시에 파란불이 들어옴
    
    
}

struct Comment: Codable {
    let id: Int
    var comment: String
    var commenter: String
}
