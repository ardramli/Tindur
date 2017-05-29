//
//  MyProfileViewController.swift
//  Tindur
//
//  Created by ardMac on 28/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    
    var ref: DatabaseReference!
    
    var currentUser = User.currentUser
    var profileUserID = ""
    var uid : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        uid = Auth.auth().currentUser?.uid
        listenToFirebase()
        // Do any additional setup after loading the view.
    }

    func listenToFirebase() {
        
        if profileUserID == "" {
            profileUserID = (uid)!
        }
        
        ref.child("users").child("male").child(profileUserID).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let dictionary = snapshot.value as? [String: Any]
            
            let currentProfileUser = User(withAnId: snapshot.key, anEmail: (dictionary?["email"])! as! String, aName: (dictionary?["name"])! as! String, aBio: "", aProfileImageURL: (dictionary?["photoURL"])! as! String)
            
            
            
            // load the profile image
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: currentProfileUser.profileImageUrl!)
            
            
            // load the user name
            self.nameAgeLabel.text = (currentProfileUser.name?.components(separatedBy: " ").first)! + ", 24"
            
        })
    }
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let currentStoryboard = UIStoryboard (name: "Auth", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        present(initController, animated: true, completion: nil)
    }
}

