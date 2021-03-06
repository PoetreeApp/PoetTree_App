//
//  GoogleLogInViewController.swift
//  PoetTree_App
//
//  Created by κΉλν on 2021/04/03.
//

import UIKit
import GoogleSignIn
import Firebase
import Alamofire
import SwiftyJSON

protocol GoogleLogInDelegate {
    func googleLogedIn(user: GIDGoogleUser)
}

class GoogleLogInViewController: UIViewController, GIDSignInDelegate {
    
    public static var user: GIDGoogleUser!
    var delegate: GoogleLogInDelegate?
    var logOutBtnAppear: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let user = user {
        
            if let authentication = user.authentication {
                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if error != nil {
                        return
                    } else {
                        GoogleLogInViewController.user = user
                        
                        let image = user.profile.imageURL(withDimension: 96)
                        let imageURL = image?.absoluteString
                        
                        let parameter: [String : Any] =
                            [ "email" : user.profile.email,
                              "name" : user.profile.name,
                              "provider" : "Google",
                              "image" : imageURL
                            ]
                        AF.request(K.API.USER_SIGNIN, method: .post, parameters: parameter, encoding: JSONEncoding.default).response{
                            response in
                            
                            if let data = response.data {
                                let jsonData = JSON(data)
                                guard let token = jsonData["token"].string else { return }
                                print(" got token \(token)")
                                let userDefaults = UserDefaults.standard
                                userDefaults.setValue(token, forKeyPath: "token")
                            }
                        }
                        DispatchQueue.main.async {
                            self.delegate?.googleLogedIn(user: user)
                        }
                        self.dismiss(animated: true) {
                            UserPhotoManager.retrieveUser()
                            self.logOutBtnAppear?()
                        }
                    }
                }
            }
        }
    }
}
