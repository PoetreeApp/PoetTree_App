//
//  YesterdaysWriting.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/18.
//

import Foundation
import UIKit
import Alamofire

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
    
    
    var writing: WritingGet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        commentTextField.delegate = self
    }
    
    fileprivate func setUpUI(){
        titleLabel.text = writing?.title
        contentLabel.text = writing?.content
        userNameLabel.text = writing?.userName
        
        if GoogleLogInViewController.user?.profile.email == writing?.userEmail {
            correctionButton.isHidden = false
            deleteButton.isHidden = false
        } else {
            correctionButton.isHidden = true
            deleteButton.isHidden = true
            reactStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
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
    
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        // 코멘트 리스트로 넘어감
    }
    
    @IBAction func commentListBtnTapped(_ sender: UIButton) {
        // 코멘트 리스트로 넘어감
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
