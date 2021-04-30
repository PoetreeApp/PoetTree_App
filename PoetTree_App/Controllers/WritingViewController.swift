//
//  WritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/03/31.
//

import UIKit
import Alamofire

class WritingViewController: UIViewController {

    var keyWord: [String]?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var keyWordLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.hidesBackButton = true
       
        setTimeLabel()
        setKeyWordLabel()
    }
    
    
    //MARK: - updateUI
    fileprivate func setTimeLabel(){
        let date = Date()
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_kr")
        format.dateFormat = "YYYY년 M월 d일 EEE HH:mm"
        let timestamp = format.string(from: date)
        self.timeLabel.text = timestamp
    }

    fileprivate func setKeyWordLabel(){
        
        if let keyWord = keyWord {
            keyWordLabel.text = "\(keyWord[0]) \(keyWord[1])"
        }
    }
    
    //MARK: - Back
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - WriteBtnTapped
    @IBAction func writeBtnTapped(_ sender: UIButton) {
        
        if let title = titleTextField.text,
           let content = contentTextField.text,
           let email = GoogleLogInViewController.user.profile.email,
           let hashtags = keyWord {
            
            let writing = Writing(title: title, content: content, email: email, hashtags: hashtags)
            
            
            let parameter: [String : Any] =
                [ "title" : writing.title,
                  "content" : writing.content,
                  "email" : writing.email,
                  "hashtags": "\(writing.hashtags[0]), \(writing.hashtags[1])"
                ]
            
            
            AF.request(K.API.WRITING_GET_POST, method: .post, parameters: parameter, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
                response in
                
                debugPrint(response)
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
}
