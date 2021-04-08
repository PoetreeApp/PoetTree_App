//
//  YesterDayMainViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/01.
//

import UIKit
import Alamofire
import SwiftyJSON

class YesterDayMainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yesterday viewdidload called")
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //매번 불림
        
        let a = WritingService.shared
        
    }
    
}

extension YesterDayMainViewController: UITableViewDelegate {
    
}

extension YesterDayMainViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
