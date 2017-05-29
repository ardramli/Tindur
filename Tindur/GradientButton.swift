//
//  GradientButton.swift
//  Tindur
//
//  Created by ardMac on 29/05/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit

@IBDesignable

class GradientButton: UIButton {
    @IBInspectable var FirstColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
    }
}

