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

class CommentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    
    //해당 게시물의 id를 받아옴
    var comment: [Comment]?
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self
        setTableView()
    }
    
    fileprivate func setTableView(){
        
        
        
    }
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        
        guard let comment = commentTextField.text,
              let id = self.id
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
    
    //완료되면 table view reload
}

class WritingCommentCell: UITableViewCell {
    
    @IBOutlet weak var commenter: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    fileprivate func updateComment(comment: Comment){
        commenter.text = comment.comment
        commentLabel.text = comment.comment
    }
    
}
