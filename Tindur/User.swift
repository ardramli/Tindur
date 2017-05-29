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
    var bio : String?
    var profileImageUrl : String?
//    var preference : String?
//    var gender : String?
    
    
    init() {
        id = ""
        email = ""
        name = ""
        bio = ""
        profileImageUrl = ""
//        preference = ""
//        gender = ""
    }
    
    init(withAnId : String, anEmail : String, aName : String, aBio : String, aProfileImageURL : String) {
        id = withAnId
        email = anEmail
        name = aName
        bio = aBio
        profileImageUrl = aProfileImageURL
//        preference = aPreference
//        gender = aGender
    }
}
