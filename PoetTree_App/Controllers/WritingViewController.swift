//
//  WritingViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/03/31.
//

import UIKit

class WritingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
