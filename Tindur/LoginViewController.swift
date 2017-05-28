//
//  LoginViewController.swift
//  Tindur
//
//  Created by ardMac on 27/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class LoginViewController: UIViewController {

    var photoURL : String?
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook - \(error?.localizedDescription ?? "")")
            } else if result?.isCancelled == true {
                print("User cancelled Facebook authentication")
            } else {
                print("Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.handleAuth(credential)
                self.indicatorStart()
            }
        }
    }
    func handleAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase - \(String(describing: error?.localizedDescription))")
            } else {
                print("Successfully authenticated with Firebase")
                self.photoURL = "\((user!.photoURL)!)"
                if let user = user, let name = user.displayName, let email = user.email, let photo = self.photoURL {
                    
                    let values = ["name": name, "email": email, "photoURL" : photo] as [String : Any]
                    Database.database().reference().child("users").child("male").child(user.uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err!)
                            return
                        }
                    })
                    self.registerButtonToNextVC()
                }
            }
        })
    }
    func registerButtonToNextVC(){
        let currentStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "MainNavController")
        activityIndicator.stopAnimating()
        present(initController, animated: true, completion: nil)
    }
    
    func indicatorStart(){
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
}
