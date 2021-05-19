//
//  YesterdayPhotoCorrectionViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/19.
//

import UIKit
import Alamofire

class YesterdayPhotoCorrectionViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hashtagTextField1: UITextField!
    @IBOutlet weak var hashtagTextField2: UITextField!
    
    var writing: WritingGet?
    
    var changeUI: ((Writing) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashtagTextField1.delegate = self
        hashtagTextField2.delegate = self
        
        setupUI()
    }
    
    func setupUI(){
        
        
        guard let writing = self.writing else {return}
        
        titleTextField.text = writing.title
        userLabel.text = writing.userName
        contentTextView.text = writing.content
        imageView.image = writing.image
        
        
        let hashtags = writing.hashtags
        let hashtagsArr = hashtags.components(separatedBy: " ")
        self.hashtagTextField1.text = hashtagsArr[0]
        self.hashtagTextField2.text = hashtagsArr[1]
        
    }
    
    
    @IBAction func completeBtn(_ sender: UIButton) {
        
        guard let id = writing?.id,
              let writing = self.writing,
              let title = titleTextField.text,
              let content = contentTextView.text,
              let hashtag1 = hashtagTextField1.text,
              let hashtag2 = hashtagTextField2.text else {return}
        
        let parameters: [String: Any] = ["title" : title, "content" : content, "email" : writing.userEmail, "hashtags" : "\(hashtag1) \(hashtag2)"]
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            
            let writing = Writing(title: title, content: content, email: writing.userEmail, hashtags: [hashtag1, hashtag2])
            self.changeUI?(writing)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension YesterdayPhotoCorrectionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {return false}
        
        let filteredText = text.filter{$0 != "#"}
        
        let finalText = "#\(filteredText)"
        
        if self.hashtagTextField1.isFirstResponder {
            
            self.hashtagTextField1.text = finalText
        }
        
        if self.hashtagTextField2.isFirstResponder {
            self.hashtagTextField2.text = finalText
        }
        
        return true
    }
}

//toPhotoCorrection
