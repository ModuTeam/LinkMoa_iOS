//
//  RegisterNextButtonView.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/12.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit

import RxSwift

final class LinkMoaButtonView: UIView, ObserverType {
    typealias Element = Bool
    
    func on(_ event: Event<Element>) {
        switch event {
        case .next(let isEnable):
            backgroundColor = isEnable ? .linkMoaDarkBlueColor : .linkMoaOptionBackgroundColor
        default:
            break
        }
    }
}
