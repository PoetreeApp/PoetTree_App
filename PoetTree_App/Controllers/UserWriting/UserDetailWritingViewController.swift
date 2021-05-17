//
//  UserDetailWritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/17.
//

import UIKit
import Alamofire

class UserDetailWritingViewController: UIViewController {
    
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    var userWriting: UserWriting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    fileprivate func setUI(){
        self.selectedImageView.image = userWriting?.image
        
    }
    
    
    @IBAction func correctionBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        
        guard let id = self.userWriting?.id else {return}
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            print("삭제 성공")
            self.navigationController?.popViewController(animated: true)
            
        }
    }
}
