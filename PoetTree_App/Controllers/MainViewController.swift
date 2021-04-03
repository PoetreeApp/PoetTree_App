//
//  MainViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/03/31.
//

import UIKit
import GoogleSignIn

class MainViewController: UIViewController, GoogleLogInDelegate {
    
    
    @IBOutlet weak var toDaysPhoto: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Today's Photo", attributes: underlineAttribute)
        toDaysPhoto.attributedText = underlineAttributedString
        
    }
    
    func googleLogedIn(user: GIDGoogleUser) {
        print("change bar button")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(moveToUserWriting))
    }
    
    @objc fileprivate func moveToUserWriting(){
        print("move To user writing")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear celled")
    }
    
    
    @IBAction func userIconTapped(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: K.SEGUE_ID.toUserWriting, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.SEGUE_ID.toLogIn {
            
            guard let destinationVC = segue.destination as? GoogleLogInViewController else {
                return
            }
            destinationVC.delegate = self
        }
    }
    
    @IBAction func writeBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.SEGUE_ID.toWriting, sender: self)
    }
    
    
    
}
