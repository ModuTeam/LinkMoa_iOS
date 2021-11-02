//
//  Observable.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/06.
//

import Foundation

public final class LMObservable<T> {
    public typealias Observer = (T) -> Void
    
    public var observer: Observer?
    
    public var value: T {
        didSet {
            observer?(value)
        }
    }

    public init(_ value: T) {
        self.value = value
    }
    
    public func bind(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
