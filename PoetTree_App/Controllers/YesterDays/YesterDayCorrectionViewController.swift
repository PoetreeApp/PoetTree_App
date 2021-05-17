//
//  YesterDayCorrectionViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/02.
//

import UIKit
import Alamofire

//해시태그 수정기능

class YesterDayCorrectionViewController: UIViewController {
    
    var writing: WritingGet?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var hashtag1TextField: UITextField!
    @IBOutlet weak var hashtag2TextField: UITextField!
    
    
    
    var changeUI: ((Writing) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashtag1TextField.delegate = self
        hashtag2TextField.delegate = self
        
        setupUI()
    }
    
    func setupUI(){
        
        
        guard let writing = self.writing else {return}
        
        titleTextField.text = writing.title
        userIdLabel.text = writing.userName
        contentTextView.text = writing.content
        selectedImage.image = writing.image
        
        
        let hashtags = writing.hashtags
        let hashtagsArr = hashtags.components(separatedBy: " ")
        self.hashtag1TextField.text = hashtagsArr[0]
        self.hashtag2TextField.text = hashtagsArr[1]
        
    }
    
    @IBAction func completeBtnTapped(_ sender: UIButton) {

        guard let id = writing?.id,
              let writing = self.writing,
              let title = titleTextField.text,
              let content = contentTextView.text,
              let hashtag1 = hashtag1TextField.text,
              let hashtag2 = hashtag2TextField.text else {return}
        
        let parameters: [String: Any] = ["title" : title, "content" : content, "email" : writing.userEmail, "hashtags" : "\(hashtag1) \(hashtag2)"]
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            
            let writing = Writing(title: title, content: content, email: writing.userEmail, hashtags: [hashtag1, hashtag2])
            self.changeUI?(writing)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension YesterDayCorrectionViewController: UITextFieldDelegate {
    
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
