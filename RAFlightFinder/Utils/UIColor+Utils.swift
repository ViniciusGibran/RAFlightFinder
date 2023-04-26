//
//  UIColor+Utils.swift
//  Created by Vinicius Gibran on 01/07/19.
//

import UIKit

extension UIColor {
    
    @nonobjc class var appBlue: UIColor {
        UIColor(red: 13, green: 73, blue: 192)
    }
    
    @nonobjc class var appDarkBlue: UIColor {
        UIColor(red: 7, green: 53, blue: 144)
    }
    
    @nonobjc class var appYellow: UIColor {
        UIColor(red: 241, green: 203, blue: 49)
    }
    
    @nonobjc class var defaultBackround: UIColor {
        UIColor(red: 239, green: 239, blue: 244)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(Double(red) / 255.0),
                  green: CGFloat(Double(green) / 255.0),
                  blue: CGFloat(Double(blue) / 255.0),
                  alpha: 1)
    }    
}
