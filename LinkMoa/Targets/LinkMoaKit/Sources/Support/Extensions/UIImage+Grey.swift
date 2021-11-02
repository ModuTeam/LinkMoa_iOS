//
//  UIImage+Grey.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/21.
//

import UIKit

public extension UIImage {
    var greyScale: UIImage? {
        guard let filter = CIFilter(name: "CIExposureAdjust"),
              let image = CIImage(image: self)
        else {
            return nil
        }
        
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(-0.5, forKey: kCIInputEVKey)
        
        if let ciImage = filter.outputImage {
            return UIImage(ciImage: ciImage)
        } else {
            return nil
        }
    }
}
