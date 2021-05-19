//
//  UserLikedWritingCommentViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserLikedWritingCommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var writingId: Int?
    var comments: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
        print(comments)
    }
    
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        
        guard let commentText = commentTextField.text,
              !commentText.isEmpty
              else {return}
        
        guard let comment = commentTextField.text,
              let writingId = self.writingId,
              let user = GoogleLogInViewController.user
        else {return}
        
        let parameter: [String : Any] = [
            "comment" : comment
        ]
        
        AF.request(K.API.LIKE_POST + "\(writingId)/comment", method: .post, parameters: parameter, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response {
            response in
            
            self.comments?.append(Comment(id: writingId, comment: comment, commenter: user.profile.name, commenterEmail: user.profile.email))
            
            self.tableView.reloadData()
        }
        self.commentTextField.text?.removeAll()
    }
    
}
extension UserLikedWritingCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.TABLE_VIEW_CELL_ID.commentCell, for: indexPath) as? LikedCommentCell,
              let comments = self.comments else {return UITableViewCell()}
        
        let comment = comments[indexPath.row]
        
        cell.update(comment: comment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let writingId = writingId,
                  let currentComment = self.comments else {return}
            
            let commentId = currentComment[indexPath.row].id
            
            AF.request(K.API.COMMENT_DELETE+"\(writingId)/\(commentId)", method: .delete, interceptor: RequestInterceptor()).response{
                response in
                print("댓글 삭제 성공")
            }
            self.comments?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension UserLikedWritingCommentViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
      
        guard let text = textField.text else {return}
       
        if !text.isEmpty{
            print("change called")
            postBtn.setTitleColor(UIColor.link, for: .normal)
        } else {
            postBtn.setTitleColor(UIColor(named: "emptyPostColor"), for: .normal)
        }
    }
}

class LikedCommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func update(comment: Comment){
        //이미지를 받아와서 업데이트 함
        
        userLabel.text = comment.commenter
        contentLabel.text = comment.comment
    }
    
}
