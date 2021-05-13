//
//  WritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/03/31.
//

import UIKit
import Alamofire

// 포스팅을 소스아이디와 함께 post하기

// 이미지를 상단에 표시하기

// 키보드 대응, 텍스트 필드 place holder 설정

class WritingViewController: UIViewController {

    var keyWord: [String]?
    var sourceID: Int?
    var selectedPhoto: UIImage?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var keyWordLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var selectedImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextField.delegate = self
        self.navigationController?.navigationItem.hidesBackButton = true
       
        contentTextField.text = "시 쓰기"
        contentTextField.textColor = UIColor.lightGray
        
        setTimeLabel()
        setKeyWordLabel()
        setImageView()
    }
    
    
    //MARK: - UpdateUI
    
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
            keyWordLabel.text = " \(keyWord[0]) \(keyWord[1])"
        }
    }
    
    fileprivate func setImageView(){
        guard let selectedImage = self.selectedPhoto else { return }
        
        self.selectedImage.image = selectedImage
        
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
            
            
            //소스 아이디를 같이 보냄
            
            let parameter: [String : Any] =
                [ "title" : writing.title,
                  "content" : writing.content,
                  "email" : writing.email,
                  "hashtags": "\(writing.hashtags[0]), \(writing.hashtags[1])"
                ]
            
            guard let sourceID = self.sourceID else {return}
            
            AF.request(K.API.WRITING_GET_POST+"?SourceId=\(sourceID)", method: .post, parameters: parameter, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
                response in
                
                debugPrint(response)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension WritingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}
