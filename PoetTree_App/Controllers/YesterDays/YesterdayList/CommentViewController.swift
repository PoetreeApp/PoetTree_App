//
//  CommentViewController.swift
//  PoetTree_App
//
//  Created by κΉλν on 2021/05/12.
//

import UIKit
import Alamofire

protocol AddCommentDelegate {
    func addComment(comments: [Comment])
}

class CommentViewController: UIViewController{
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    
    var delegate: AddCommentDelegate?
    var comment: [Comment]?
    var writingId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("i called")
        commentTextField.delegate = self
        self.commentTableView.reloadData()
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
            
            self.comment?.append(Comment(id: writingId, comment: comment, commenter: user.profile.name, commenterEmail: user.profile.email))
            
            self.commentTableView.reloadData()
        }
        self.commentTextField.text?.removeAll()
    }
    
    
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        
        guard let delegate = self.delegate,
              let comments = self.comment else {return}
        
        delegate.addComment(comments: comments)
       
        self.navigationController?.popViewController(animated: true)
    }
}

extension CommentViewController: UITextFieldDelegate {
    
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

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let commentCount = self.comment?.count else {return 0}
        
        return commentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.TABLE_VIEW_CELL_ID.commentCell, for: indexPath) as? WritingCommentCell else {return UITableViewCell()}
        
        guard let comment = self.comment?[indexPath.row] else {return UITableViewCell()}
        
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
                  let currentComment = self.comment else {return}
            
            let commentId = currentComment[indexPath.row].id
            
            AF.request(K.API.COMMENT_DELETE+"\(writingId)/\(commentId)", method: .delete, interceptor: RequestInterceptor()).response{
                response in
                print("λκΈ μ­μ  μ±κ³΅")
            }
            self.comment?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

class WritingCommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commenter: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.7
        profileImageView.clipsToBounds = true
    }
    
    fileprivate func updateComment(comment: Comment){
        commenter.text = comment.commenter
        commentLabel.text = comment.comment
    }
    
    func update(comment: Comment, image: UIImage){
      
        profileImageView.image = image
        commenter.text = comment.commenter
        commentLabel.text = comment.comment
    }
    
}
