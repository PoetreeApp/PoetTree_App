//
//  UserInfoViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/01.
//

import UIKit
import Alamofire
import SwiftyJSON

// 로그인한 유저의 글들을 불러와서 테이블 뷰에 뿌리기
// 로그아웃 구현하기

class UserWritingViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var userWritings: [WritingGet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.hidesBackButton = true
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
            debugPrint(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                for (index, json) in json {
                    print(index)
                    
                    if let title = json["title"].string,
                       let content = json["content"].string,
                       let views = json["views"].int,
                       let id = json["id"].int,
                       let email = json["UserEmail"].string,
                       let userName = json["name"].string{
                        print("user post title \(title)")
                        
                        
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
