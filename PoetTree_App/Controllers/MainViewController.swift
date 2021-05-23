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

// 전시 끝나고 할 것
// 1. 코드 dry 하게 정리
// - 수정, 삭제, 글쓰기 여러 개 중복되는 코드들 정리
// 2. UI 개선
// - 여러 디자인 사이트들 참고하기, history by photo 탭 스크롤 뷰 추가, 메인 페이지 사진 선택 기능 개선, ui개선
// 3. 키보드 대응
// - 글쓰는 여러 vc에서 키보드 올라올 때 키보드 대응하기
// 4. 통신 기능 보완
// - 현재 너무 느린 전환. 더 효율적인 방법을 고안, 적용

class MainViewController: UIViewController, GoogleLogInDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var toDaysPhoto: UILabel!
    @IBOutlet weak var hashTagStackView: UIStackView!
    @IBOutlet weak var keyWordTextField1: UITextField!
    @IBOutlet weak var keyWordTextField2: UITextField!
    @IBOutlet weak var wrtBtn: UIButton!
    
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet{
            
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            
            self.pagerView.itemSize = FSPagerView.automaticSize
            
            self.pagerView.isInfinite = true
            
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        }
    }
    
    @IBOutlet weak var fsPageControl: FSPageControl! {
        didSet{
            self.fsPageControl.numberOfPages = 3
            self.fsPageControl.contentHorizontalAlignment = .center
            self.fsPageControl.itemSpacing = 10
            self.fsPageControl.interitemSpacing = 15
            self.fsPageControl.setFillColor(.systemBlue, for: .selected)
            self.fsPageControl.setFillColor(.lightGray, for: .normal)
        }
    }
    
    fileprivate var todayImages: [TodaysPhoto] = []
    fileprivate var todayImageViews: [UIImage] = []
    
    var selectedPhotoIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerView.delegate = self
        pagerView.dataSource = self
        
        setupUI()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    fileprivate func underLineText(){
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Today's Photo", attributes: underlineAttribute)
        toDaysPhoto.attributedText = underlineAttributedString
    }
    
    fileprivate func setupUI(){
        
        underLineText()
        
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        getPhotos { todayPhotos in
            
            let images: [UIImage] = todayPhotos.map{ photo in
                let url = photo.imageURL
                let data = try! Data(contentsOf: url)
                let image = UIImage(data: data)
                return image!
            }
            
            DispatchQueue.main.async {
                self.todayImages = todayPhotos
                self.todayImageViews = images
                self.pagerView.reloadData()
            }
        }
    }
   
    
    fileprivate func getPhotos(completion: @escaping (([TodaysPhoto]) -> Void)){
        //사진을 받아서 배열에 넣음
        
            AF.request(K.API.PHOTOS_GET, method: .get).responseJSON { [weak self] response in

                guard let self = self else {return}
                switch response.result {
                case .success(let sources):

                    let json = JSON(sources)
                    var todayPhotos: [TodaysPhoto] = []
                    for (index, json) in json {
                        if let id = json["id"].int,
                           let url = json["imageURL"].string,
                           let imageURL = URL(string: url){
                            todayPhotos.append(TodaysPhoto(id: id, imageURL: imageURL))
                        }
                    }
                    
                    completion(todayPhotos)
          
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }

    //MARK: - keyboard 에따른 view 설정
    
    
    

    
    //MARK: - after logIn delegate function
    func googleLogedIn(user: GIDGoogleUser) {
        print("change bar button")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(moveToUserWriting))
        self.hashTagStackView.isHidden = false
        self.toDaysPhoto.isHidden = true
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "LogOutColor")
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
            destinationVC.logOutBtnAppear = {
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "LogOutColor")
                
            }
        }
        
        if segue.identifier == K.SEGUE_ID.toWriting {
    
            guard let destinationVC = segue.destination as? WritingViewController else {
                return
            }
            
            if let keyWord1 = self.keyWordTextField1.text,
            let keyWord2 = self.keyWordTextField2.text{
                
                destinationVC.keyWord = ["#"+keyWord1, "#"+keyWord2]
                destinationVC.sourceID = self.todayImages[selectedPhotoIndex].id
                destinationVC.selectedPhoto = self.todayImageViews[selectedPhotoIndex]
            }
        }
    }
    //MARK: - WriteBtn Tapped func
    @IBAction func writeBtnTapped(_ sender: UIButton) {
        
        if let currentUser = GoogleLogInViewController.user {
            self.performSegue(withIdentifier: K.SEGUE_ID.toWriting, sender: self)
        } else {
            self.view.makeToast("글쓰기는 로그인 후 가능합니다", duration: 2.0, position: .center)
        }
    }
    
    //MARK: - 제스처 recognizer
    
    
    
    
    @IBAction func logOutBtnTapped(_ sender: UIBarButtonItem) {
        GoogleLogInViewController.user = nil
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(goToLogIn))
        sender.tintColor = .white
        self.hashTagStackView.isHidden = true
        self.toDaysPhoto.isHidden = false
    }
//    goToLogIn
    @objc func goToLogIn(){
        performSegue(withIdentifier: "goToLogIn", sender: self)
    }
}

extension MainViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        print(self.todayImageViews.count)
        return self.todayImageViews.count
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = self.todayImageViews[index]
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        selectedPhotoIndex = targetIndex
        self.fsPageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.fsPageControl.currentPage = pagerView.currentIndex
    }
}
