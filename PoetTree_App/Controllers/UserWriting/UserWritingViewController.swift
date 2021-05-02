//
//  UserInfoViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/01.
//

import UIKit

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
    
    
    //글추가하면 delegate으로 추가
    
    
    
}
