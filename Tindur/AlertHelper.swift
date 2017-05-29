//
//  AlertHelper.swift
//  Tindur
//
//  Created by ardMac on 29/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit


extension UIViewController{
    func warningPopUp(withTitle title : String?, withMessage message : String?){
        let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        popUP.addAction(okButton)
        present(popUP, animated: true, completion: nil)
    }
}
