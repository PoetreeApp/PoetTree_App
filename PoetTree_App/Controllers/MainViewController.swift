//
//  MainViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/03/31.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var toDaysPhoto: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Today's Photo", attributes: underlineAttribute)
        toDaysPhoto.attributedText = underlineAttributedString
        
    }
    
    
    @IBAction func userIconTapped(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: K.SEGUE_ID.toUserInfo, sender: self)
        
    }
    
    
    
    
    @IBAction func writeBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.SEGUE_ID.toWriting, sender: self)
    }
    
    
    
}
