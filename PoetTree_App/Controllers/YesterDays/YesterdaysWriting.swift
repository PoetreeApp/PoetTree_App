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
    
    
    
    var writing: WritingGet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
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
}
