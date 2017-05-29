//
//  ViewController.swift
//  Tindur
//
//  Created by ardMac on 27/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//
import UIKit
import DMSwipeCards
import Firebase


class ViewController: UIViewController {
    
    private var swipeView: DMSwipeCardsView<String>!
    private var count = 0
    
    var users = [User]()
    var currentUser = User()
    var imageURL : String?
    var currentUserTapped = User()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    func setupCardView(){
        var index = 0
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            index = Int(element)!
            
            let container = UIView(frame: CGRect(x: 15, y: 20, width: frame.width - 60, height: frame.height - 40))
            
            let cardImageView = UIImageView(frame: container.bounds)
            
            cardImageView.loadImageUsingCacheWithUrlString(urlString: self.users[index].profileImageUrl!)
            cardImageView.center = container.center
            cardImageView.clipsToBounds = true
            cardImageView.layer.cornerRadius = 16
            container.addSubview(cardImageView)
            container.addSubview(cardImageView)
            let userNamelabel = UILabel(frame: container.bounds)
            
            userNamelabel.text = self.users[index].name
            userNamelabel.numberOfLines = 10
            userNamelabel.textAlignment = .center
            userNamelabel.textColor = UIColor.white
            userNamelabel.font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold)
            userNamelabel.frame = CGRect(x: 15, y: 300, width: 300, height: 100)
            
            
            container.addSubview(userNamelabel)
            
            container.layer.shadowRadius = 4
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = true
            container.layer.rasterizationScale = UIScreen.main.scale
            
            
            return container
        }
        
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            let label = UILabel()
            label.frame.size = CGSize(width: 100, height: 100)
            label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            label.layer.cornerRadius = label.frame.width / 2
            
            label.backgroundColor = mode == .left ? UIColor.red : UIColor.green
            label.clipsToBounds = true
            label.text = mode == .left ? "👎" : "👍"
            label.font = UIFont.systemFont(ofSize: 24)
            label.textAlignment = .center
            
            return label
        }
        
        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
        
        
        swipeView = DMSwipeCardsView<String>(frame: frame,
                                             viewGenerator: viewGenerator,
                                             overlayGenerator: overlayGenerator)
        swipeView.delegate = self
        self.view.addSubview(swipeView)
        self.swipeView.addCards((0...users.count - 1 ).map({"\($0)"}))
        
    }
    
    
    func fetchUser() {
        Database.database().reference().child("users").child("female").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.id = snapshot.key
                
                let currentProfileUser = User(withAnId: snapshot.key, anEmail: (dictionary["email"])! as! String, aName: (dictionary["name"])! as! String, aBio: "", aProfileImageURL: (dictionary["photoURL"])! as! String)
                
                self.users.append(currentProfileUser)
                
                DispatchQueue.main.async {
                    self.setupCardView()
                    
                }
            }
        }, withCancel: nil)
    }
    
    func checkForMatches(index: Int){
        Database.database().reference().child("users").child("female").child(users[index].id!).child("likes")
            .observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                
                if snapshot.key == Auth.auth().currentUser!.uid {
                    Database.database().reference().child("matches").child("\(self.users[index].id!) - \(Auth.auth().currentUser!.uid)").updateChildValues(["1": true])
                    self.warningPopUp(withTitle: "It's a MATCH!", withMessage: "Now you guys can talk")
                }
            }, withCancel: nil)
    }
    
}

extension ViewController: DMSwipeCardsViewDelegate {
    func swipedLeft(_ object: Any) {
        print("Swiped left: \(object)")
    }
    
    func swipedRight(_ object: Any) {
        print("Swiped right: \(object)")
        let index = (object as AnyObject).integerValue
        print("Swiped right: \(String(describing: index!))")
        
        print(self.users[index!].id!)
        Database.database().reference().child("users").child("male").child(Auth.auth().currentUser!.uid).updateChildValues(["likes/\(self.users[index!].id!)" : true ])
       checkForMatches(index: index!)

        
    }
    
    func cardTapped(_ object: Any) {
        print("Tapped on: \(object)")
        let index = (object as AnyObject).integerValue
        
        Database.database().reference().child("users").child("female").child(users[index!].id!).observe(.value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.id = snapshot.key
                
                let currentProfileTapped = User(withAnId: snapshot.key, anEmail: (dictionary["email"])! as! String, aName: (dictionary["name"])! as! String, aBio: "", aProfileImageURL: (dictionary["photoURL"])! as! String)
                self.currentUserTapped = currentProfileTapped
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                guard let controller = storyboard .instantiateViewController(withIdentifier: "ProfileViewController") as?
                    ProfileViewController else { return }
                controller.currentUserTapped = self.currentUserTapped
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }, withCancel: nil)
        
        
    }
    
    func reachedEndOfStack() {
        print("Reached end of stack")
    }
}

