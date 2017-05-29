//
//  EditProfileViewController.swift
//  Tindur
//
//  Created by ardMac on 29/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var preferenceSegmentedControl: UISegmentedControl!

    var ref: DatabaseReference!
    var authUser = Auth.auth().currentUser
    var currentUserID : String = ""
    var currentUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        if let id = authUser?.uid {
            currentUserID = id
        }
        setupView()
    }
    
    func saveButtonTapped(){
        
        let user : [String : String] = ["name" : nameTextField.text!,"bio" : bioTextView.text]
        self.ref.child("users").child("male").child(currentUserID).updateChildValues(user)
        
    }
    
    func setupView(){
        ref.child("users").child("male").child(currentUserID).observe(.value, with: { (snapshot) in
            print(snapshot)
            
            let dictionary = snapshot.value as? [String: Any]
            let currentProfileUser = User(withAnId: (snapshot.key), anEmail: (dictionary?["email"])! as! String, aName: (dictionary?["name"])! as! String, aBio: (dictionary?["bio"])! as! String, aProfileImageURL: (dictionary?["photoURL"])! as! String)
            
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: currentProfileUser.profileImageUrl!)
            self.nameTextField.text = currentProfileUser.name
            self.bioTextView.text = currentProfileUser.bio
            
        }, withCancel: nil)
        
    }
    

}
