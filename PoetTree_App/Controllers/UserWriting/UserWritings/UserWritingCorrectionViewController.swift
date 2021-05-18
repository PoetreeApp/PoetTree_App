//
//  UserWritingCorrectionViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/17.
//

import UIKit
import Alamofire

class UserWritingCorrectionViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hashtag1TextField: UITextField!
    @IBOutlet weak var hashtag2TextField: UITextField!
    
    
    var changeUI: ((Writing) -> Void)?
    var userWriting: UserWriting?
    var hashtags: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashtag1TextField.delegate = self
        hashtag2TextField.delegate = self
        setUI()
    }
    
    fileprivate func setUI(){
        
        titleTextField.text = userWriting?.title
        userLabel.text = userWriting?.name
        contentTextView.text = userWriting?.content
        imageView.image = userWriting?.image
        
        guard let hashtags = self.hashtags else {return}
        
        let hashtagsArr = hashtags.components(separatedBy: " ")
        self.hashtag1TextField.text = hashtagsArr[0]
        self.hashtag2TextField.text = hashtagsArr[1]
        
    }
    
    
    @IBAction func completeBtnTapped(_ sender: UIButton) {
        
        guard let id = userWriting?.id,
              let user = GoogleLogInViewController.user,
              let title = titleTextField.text,
              let content = contentTextView.text,
              let hashtag1 = hashtag1TextField.text,
              let hashtag2 = hashtag2TextField.text else {return}
        
        let parameters: [String: Any] = ["title" : title, "content" : content, "email" : user.profile.email, "hashtags" : "\(hashtag1) \(hashtag2)"]
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            print(response)
            let writing = Writing(title: title, content: content, email: user.profile.email, hashtags: [hashtag1, hashtag2])
            self.changeUI?(writing)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension UserWritingCorrectionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {return false}
        
        let filteredText = text.filter{$0 != "#"}
        
        let finalText = "#\(filteredText)"
        
        if self.hashtag1TextField.isFirstResponder {
            
            self.hashtag1TextField.text = finalText
        }
        
        if self.hashtag2TextField.isFirstResponder {
            self.hashtag2TextField.text = finalText
        }
        
        return true
    }
}
