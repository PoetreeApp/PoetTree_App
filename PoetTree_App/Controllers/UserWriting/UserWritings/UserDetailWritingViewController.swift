//
//  UserDetailWritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/17.
//

import UIKit
import Alamofire
import SwiftyJSON
//좋아요, 댓글, 수정

class UserDetailWritingViewController: UIViewController {
    
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    
    var userWriting: UserWriting?
    var hashtags: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHashTag(id: userWriting?.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("vwacalled")
        setUI()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SEGUE_ID.toUserWritingCorrection {
            guard let vc = segue.destination as? UserWritingCorrectionViewController else {return}
            
            vc.userWriting = self.userWriting
            vc.hashtags = self.hashtags
            vc.changeUI = { writing in
                
                self.userWriting?.title = writing.title
                self.userWriting?.content = writing.content
                self.hashtags = "\(writing.hashtags[0]) \(writing.hashtags[1])"

                self.hashtagLabel.text = self.hashtags
                
            }
        }
    }
    
    fileprivate func setHashTag(id: Int?){
        
        guard let id = id else {return}
        
        AF.request(K.API.WRITING_GET_POST + "\(id)", method: .get).responseJSON { [weak self] response in
            
            guard let self = self else {return}
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let hashtags = json["hashtags"].string {
                    
                    self.hashtags = hashtags
                    self.hashtagLabel.text = hashtags
                }
            
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    fileprivate func setUI(){
        self.selectedImageView.image = userWriting?.image
        self.titleLabel.text = userWriting?.title
        self.contentLabel.text = userWriting?.content
        self.userLabel.text = userWriting?.name
        self.hashtagLabel.text = hashtags
    }
    
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        
        guard let id = self.userWriting?.id else {return}
        
        AF.request(K.API.WRITING_GET_POST+"\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default, interceptor: RequestInterceptor()).response{
            response in
            print("삭제 성공")
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func commentBtnTapped(_ sender: UIButton) {
    }
    
    
}
