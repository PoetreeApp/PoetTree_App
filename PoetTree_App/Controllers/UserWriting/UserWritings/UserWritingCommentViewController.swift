//
//  UserWritingCommentViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/18.
//

import UIKit
import Alamofire
import SwiftyJSON

//커멘트를 받아오고, 그 커멘트의 이메일을 받아와서
//해당 이메일의 이미지 url을 받아서 이미지로 변환한 다음 cell에 넘긴다

class UserWritingCommentViewController: UIViewController {
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var postBtn: UIButton!
    
//    let userPhotoViewModel = UserListViewModel()
    
    var writingId: Int?
    var comments: [Comment]?
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
//        userPhotoViewModel.retrieveUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            
            self.commentTableView.reloadData()
        }
        self.commentTextField.text?.removeAll()
    }
    
}


extension UserWritingCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.TABLE_VIEW_CELL_ID.commentCell, for: indexPath) as? UserCommentCell,
              let comments = self.comments else {return UITableViewCell()}
        
        let comment = comments[indexPath.row]
        
        let image = getUser(comment: comment, users: UserPhotoManager.userPhotos)
       
        cell.update(comment: comment, image: image)
        return cell
    }
    
    func getUser(comment: Comment, users: [UserPhoto]) -> UIImage{
        
        let writer = users.filter{$0.email == comment.commenterEmail}
        guard let user = writer.first else {return UIImage()}
        return user.image
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


class UserCommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2.7
        profileImage.clipsToBounds = true
    }
    
    func update(comment: Comment, image: UIImage){
        //이미지를 받아와서 업데이트 함
        profileImage.image = image
        userLabel.text = comment.commenter
        commentLabel.text = comment.comment
    }
    
}

extension UserWritingCommentViewController: UITextFieldDelegate {
    
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
