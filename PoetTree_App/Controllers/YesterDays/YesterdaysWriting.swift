//
//  YesterdaysWriting.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/18.
//

import Foundation
import UIKit

class YesterdaysWriting: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var correctionButton: UIButton!
    
    var writing: WritingGet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        correctionButton.addTarget(self, action: #selector(toCorrection), for: .touchUpInside)
        
        setUpUI()
    }
    
    fileprivate func setUpUI(){
        
        titleLabel.text = writing?.title
        contentLabel.text = writing?.content
        userNameLabel.text = writing?.userName
        
        //로그인한 유저와 글쓴이가 같으면 수정하기 버튼을 보여줌
        
        if GoogleLogInViewController.user?.profile.email == writing?.userEmail {
            correctionButton.isHidden = false
        } else {
            correctionButton.isHidden = true
        }
        
    }
    
    
    //수정을 누르면 글을 수정하는 페이지로 이동
    @objc fileprivate func toCorrection(){
        
        performSegue(withIdentifier: "toCorrection", sender: self)
        
    }
    
}
