//
//  ProfileViewController.swift
//  Tindur
//
//  Created by ardMac on 29/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!{
        didSet{
            bioTextView.isUserInteractionEnabled = false
        }
    }

    var currentUserTapped = User()
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.loadImageUsingCacheWithUrlString(urlString: currentUserTapped.profileImageUrl!)
        nameLabel.text = currentUserTapped.name
    }
    
    

}
