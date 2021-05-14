//
//  UserInfoViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/01.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleSignIn
import Firebase

// 로그아웃 구현하기
// 좋아요한 글들 보기

class UserWritingViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var userWritings: [UserWriting] = []
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userWritings.removeAll()
        getWritings()
        tableView.reloadData()
    }
    
    func getWritings(){
        AF.request(K.API.USER_WRITINGS, method: .get, interceptor: RequestInterceptor()).responseJSON { [weak self] response in
            
            guard let self = self else {return}
//            debugPrint(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                for (index, post) in json {
                    
                    if let title = post["title"].string,
                       let content = post["content"].string,
                       let views = post["views"].int,
                       let id = post["id"].int{
                       
                        self.userWritings.append(UserWriting(id: id, title: title, content: content, views: views))
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func logOutBtnTapped(_ sender: UIBarButtonItem) {
        
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            
            if let storyboard = self.storyboard {
                        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! UIViewController
                        self.present(vc, animated: false, completion: nil)
                    }
            
        } catch let signOutError as NSError {
            print("error sign out \(signOutError)")
        }
        
        
    }
    
}

extension UserWritingViewController: UITableViewDelegate {
    
}


extension UserWritingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userWritings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserPoemCell") as? UserPoemCell else { return UITableViewCell() }
        
        cell.title.text = self.userWritings[indexPath.row].title
        cell.daysImage.image = UIImage(named: "image")
        
        return cell
    }
}
