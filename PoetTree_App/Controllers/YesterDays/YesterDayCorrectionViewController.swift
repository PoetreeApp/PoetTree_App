//
//  YesterDayCorrectionViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/02.
//

import UIKit
import Alamofire


class YesterDayCorrectionViewController: UIViewController {
    
    //이전 글을 받아 옴
    var writing: WritingGet?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    var changeUI: ((Writing) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        titleTextField.text = writing?.title
        userIdLabel.text = writing?.userName
        contentTextView.text = writing?.content
    }
    
    @IBAction func completeBtnTapped(_ sender: UIButton) {

        guard let id = writing?.id,
              let writing = self.writing,
              let title = titleTextField.text,
              let content = contentTextView.text else {return}
        
        let parameters: [String: Any] = ["title" : title, "content" : content, "email" : writing.userEmail, "hashtags" : "#sadf"]
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            
            let writing = Writing(title: title, content: content, email: writing.userEmail, hashtags: ["#dd", "#frr"])
            self.changeUI?(writing)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
