//
//  YesterdaysWriting.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/18.
//

import Foundation
import UIKit

class YesterdaysWriting: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    var writing: WritingGet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    fileprivate func setUpUI(){
        
        titleLabel.text = writing?.title
        contentLabel.text = writing?.content
    }
}
