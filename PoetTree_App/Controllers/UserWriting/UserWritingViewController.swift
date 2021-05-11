//
//  UserInfoViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/01.
//

import UIKit

// 로그인한 유저의 글들을 불러와서 테이블 뷰에 뿌리기

class UserWritingViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.hidesBackButton = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UserWritingViewController: UITableViewDelegate {
    
}


extension UserWritingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserPoemCell") as? UserPoemCell else { return UITableViewCell() }
        
        cell.title.text = "스며드는 것"
        cell.daysImage.image = UIImage(named: "image")
        
        return cell
    }
}
