//
//  CommentViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/12.
//

import UIKit
import Alamofire

class CommentViewController: UIViewController, UITextFieldDelegate {
     
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    
    //해당 게시물의 id를 받아옴
    var comment: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self
        setTableView()
    }
    
    fileprivate func setTableView(){
        print(comment)
        //커멘트들로 테이블 뷰 세팅
        
    }
    
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        
        //코멘트 포스트함
    }
}
