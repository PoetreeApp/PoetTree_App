//
//  CommentViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/12.
//

import UIKit
import Alamofire

//커멘트들을 테이블 뷰에 뿌림
//커멘트 수정 vc 추가해야함

class CommentViewController: UIViewController{
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    
    
    
    //해당 게시물의 id를 받아옴
    var comment: [Comment]?
    var id: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("i called")
        commentTextField.delegate = self
        self.commentTableView.reloadData()
    }
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        
        //아무 내용도 없으면 게시하지 못한다
        guard let commentText = commentTextField.text,
              !commentText.isEmpty
              else {return}
        
        guard let comment = commentTextField.text,
              let id = self.id,
              let user = GoogleLogInViewController.user
        else {return}
        
        let parameter: [String : Any] = [
            "comment" : comment
        ]
        
        AF.request(K.API.LIKE_POST + "\(id)/comment", method: .post, parameters: parameter, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response {
            response in
            
            self.comment?.append(Comment(id: id, comment: comment, commenter: user.profile.name))
            
            self.commentTableView.reloadData()
        }
        self.commentTextField.text?.removeAll()
    }
}

extension CommentViewController: UITextFieldDelegate {
    
    //게시에 불 들어옴
    
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
        
        cell.updateComment(comment: comment)
        
        return cell
    }
}

class WritingCommentCell: UITableViewCell {
    
    @IBOutlet weak var commenter: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    fileprivate func updateComment(comment: Comment){
        commenter.text = comment.commenter
        commentLabel.text = comment.comment
    }
    
}
