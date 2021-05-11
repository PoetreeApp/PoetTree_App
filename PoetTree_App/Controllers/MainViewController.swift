//
//  MainViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/03/31.
//

import UIKit
import GoogleSignIn
import Toast_Swift
import FSPagerView
import Alamofire
import SwiftyJSON

// 메인에 이미지 슬라이더 3개 표시하기
// writing으로 넘어갈 때 선택한 이미지 같이 보내기 -> writing에서 source id를 같이 보내야함

class MainViewController: UIViewController, GoogleLogInDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var toDaysPhoto: UILabel!
    @IBOutlet weak var hashTagStackView: UIStackView!
    @IBOutlet weak var keyWordTextField1: UITextField!
    @IBOutlet weak var keyWordTextField2: UITextField!
    @IBOutlet weak var wrtBtn: UIButton!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//            self.pagerView.itemSize = FSPagerView.automaticSize
//            self.pagerView.isInfinite = true
        }
    }
    
    fileprivate var todayImages: [TodaysPhoto] = []
    fileprivate var todayImageViews: [UIImage] = []
   
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.underLineText()
        self.config()
        self.getPhotos()
        
        pagerView.dataSource = self
        pagerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.async {
            self.pagerView.reloadData()
        }
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisappear() called")
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func underLineText(){
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Today's Photo", attributes: underlineAttribute)
        toDaysPhoto.attributedText = underlineAttributedString
    }
    
    fileprivate func config(){
        self.keyboardDismissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    fileprivate func getPhotos(){
        //사진을 받아서 배열에 넣음
        AF.request(K.API.PHOTOS_GET, method: .get).responseJSON { [weak self] response in
            
            
            guard let self = self else {return}
            switch response.result {
            case .success(let sources):
                
                let json = JSON(sources)
                for (index, json) in json {
                    if let id = json["id"].int,
                       let url = json["imageURL"].string,
                       let imageURL = URL(string: url){
                        self.todayImages.append(TodaysPhoto(id: id, imageURL: imageURL))
                        let urls = self.todayImages.map{$0.imageURL}
                        self.downloadImage(from: urls)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from urls: [URL]) {
        print("Download Started")
        
        // url 배열을 전달해서 배열을 돌면서 images에 추가함
        for url in urls {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                self.todayImageViews.append(UIImage(data: data)!)
                print(self.todayImageViews.count)
            }
        }
    }
    
    //MARK: - keyboard 에따른 view 설정
    @objc func keyboardWillShowHandle(notification: NSNotification){
        print("HomeVC - keyboardWillShowHandle() called")
        // 키보드 사이즈 가져오기

//        self.navigationController?.navigationBar.isHidden = true


        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            print("keyboardSize.height: \(keyboardSize.height)")
       
            self.wrtBtn.frame.origin.y = self.wrtBtn.frame.origin.y - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHideHandle(){
        print("HomeVC - keyboardWillHideHandle() called")
        //버튼을 다시 내림
        self.wrtBtn.frame.origin.y = self.view.frame.origin.y - 20
    }

    
    //MARK: - after logIn delegate function
    func googleLogedIn(user: GIDGoogleUser) {
        print("change bar button")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(moveToUserWriting))
        self.hashTagStackView.isHidden = false
        self.toDaysPhoto.isHidden = true
    }
    
    //MARK: - move to user writing
    @objc fileprivate func moveToUserWriting(){
    
        performSegue(withIdentifier: K.SEGUE_ID.toUserWriting, sender: self)
        
    }
    
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.SEGUE_ID.toLogIn {
            
            guard let destinationVC = segue.destination as? GoogleLogInViewController else {
                return
            }
            destinationVC.delegate = self
        }
        
        if segue.identifier == K.SEGUE_ID.toWriting {
            
            guard let destinationVC = segue.destination as? WritingViewController else {
                return
            }
            
            if let keyWord1 = self.keyWordTextField1.text,
            let keyWord2 = self.keyWordTextField2.text{
                
                destinationVC.keyWord = ["#"+keyWord1, "#"+keyWord2]
            }
        }
    }
    //MARK: - WriteBtn Tapped func
    @IBAction func writeBtnTapped(_ sender: UIButton) {
        
        if let currentUser = GoogleLogInViewController.user {
            
            self.performSegue(withIdentifier: K.SEGUE_ID.toWriting, sender: self)
        } else {
            self.view.makeToast("로그인 해주세요", duration: 2.0, position: .center)
        }
    }
    
    //MARK: - 제스처 recognizer
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if(touch.view?.isDescendant(of: hashTagStackView) == true){

            return false
        }  else {
            view.endEditing(true)
            return true
        }
    }
}

//MARK: - FSPagerView extension

extension MainViewController: FSPagerViewDelegate, FSPagerViewDataSource {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        print(self.todayImageViews.count)
        return self.todayImageViews.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = self.todayImageViews[index]
        cell.contentMode = .scaleAspectFit
        print("call")
        return cell
    }
}
