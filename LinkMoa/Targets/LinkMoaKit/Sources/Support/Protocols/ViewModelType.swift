//
//  ViewModelType.swift
//  LinkMoa
//
//  Created by won heo on 2021/05/19.
//

import Foundation

public protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
