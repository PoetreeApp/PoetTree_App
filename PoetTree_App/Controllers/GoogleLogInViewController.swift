//
//  GoogleLogInViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/03.
//

import UIKit
import GoogleSignIn
import Firebase

class GoogleLogInViewController: UIViewController {
    
    public static var user: GIDGoogleUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("googleLogIn called")
       
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        
    }
    
}
