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
        loginScrollView()
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!

    
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
    
    func loginScrollView(){
        self.scrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width/1.1)
        let scrollViewHeight = self.scrollView.frame.height
        let scrollViewWidth = self.scrollView.frame.width
        
        
        let imageOne = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let imageTwo = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let imageThree = UIImageView(frame: CGRect(x: scrollViewWidth*2, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let imageFour = UIImageView(frame: CGRect(x: scrollViewWidth*3, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        
        imageOne.image = UIImage(named: "image1")
        imageOne.layer.cornerRadius = 15
        imageOne.layer.masksToBounds = true
        imageTwo.image = UIImage(named: "image2")
        imageTwo.layer.cornerRadius = 15
        imageTwo.layer.masksToBounds = true
        imageThree.image = UIImage(named: "image3")
        imageThree.layer.cornerRadius = 15
        imageThree.layer.masksToBounds = true
        imageFour.image = UIImage(named: "image4")
        imageFour.layer.cornerRadius = 15
        imageFour.layer.masksToBounds = true
        
        self.scrollView.addSubview(imageOne)
        self.scrollView.addSubview(imageTwo)
        self.scrollView.addSubview(imageThree)
        self.scrollView.addSubview(imageFour)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width*4, height: self.scrollView.frame.height)
//        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
    }

}



//extension LoginViewController :  UIScrollViewDelegate {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
//        let pageWidth:CGFloat = scrollView.frame.width
//        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
//        self.pageControl.currentPage = Int(currentPage);
//        if Int(currentPage) == 0{
//            textLabel.text = "Discover new and interesting people nearby"
//        }else if Int(currentPage) == 1{
//            textLabel.text = "Swipe Right to anonymously like someone or Swipe left to pass"
//        }else if Int(currentPage) == 2{
//            textLabel.text = "If they also Swipe Right, it's a Match!"
//        }else{
//            textLabel.text = "Only people you've matched with can message you"
//            
//        }
//    }
//}
