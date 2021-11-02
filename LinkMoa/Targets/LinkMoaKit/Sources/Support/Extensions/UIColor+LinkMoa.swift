//
//  UIColor+.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import UIKit

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static var linkMoaBlackColor: UIColor {
        return UIColor(rgb: 0x485153)
    }
    
    static var linkMoaGrayColor: UIColor {
        return UIColor(rgb: 0x4B4B4B)
    }
    
    static var linkMoaDarkBlueColor: UIColor {
        return UIColor(rgb: 0x364788)
    }
    
    static var linkMoaDarkRedColor: UIColor {
        return UIColor(rgb: 0xe4746e)
    }
    
    static var linkMoaRedColor: UIColor {
        return UIColor(rgb: 0xef534b)
    }
    
    static var linkMoaOptionBackgroundColor: UIColor {
        return UIColor(rgb: 0xeeeeee)
    }
    
    static var linkMoaOptionTextColor: UIColor {
        return UIColor(rgb: 0xc0c0c0)
    }
    
    static var linkMoaPlaceholderColor: UIColor {
        return UIColor(rgb: 0xbdbdbd)
    }
    
    static var linkMoaFolderSeletionBorderColor: UIColor {
        return UIColor(rgb: 0xbcbdbe)
    }
    
    static var linkMoaFolderCountGrayColor: UIColor {
        return UIColor(rgb: 0x909090)
    }
    
    static var linkMoaCategoryOptionBlackColor: UIColor {
        return UIColor(rgb: 0x5c5c5c)
    }
}
