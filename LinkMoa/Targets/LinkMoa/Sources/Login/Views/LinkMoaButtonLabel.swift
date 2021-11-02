//
//  RegisterNextButtonLabel.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/12.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit

import RxSwift

final class LinkMoaButtonLabel: UILabel, ObserverType {
    typealias Element = Bool
    
    func on(_ event: Event<Element>) {
        switch event {
        case .next(let isEnable):
            textColor = isEnable ? .white : .linkMoaOptionTextColor
        default:
            break
        }
    }
}
