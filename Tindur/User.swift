//
//  User.swift
//  Tindur
//
//  Created by ardMac on 28/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import Foundation

class User {
    
    static let currentUser = User()
    
    var id: String?
    var email : String?
    var name : String?
    var desc : String?
    var profileImageUrl : String?
    
    init( ) {
        id = ""
        email = ""
        name = ""
        desc = ""
        profileImageUrl = ""
    }
    
    init(withAnId : String, anEmail : String, aName : String, aDesc : String, aProfileImageURL : String) {
        id = withAnId
        email = anEmail
        name = aName
        desc = aDesc
        profileImageUrl = aProfileImageURL
        
    }
}
