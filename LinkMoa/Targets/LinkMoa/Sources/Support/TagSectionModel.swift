//
//  TagSectionModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/06/28.
//

import Foundation

import RxDataSources
import RxCocoa
import RxSwift

struct TagSectionModel {
    var items: [Item]
    var uniqueID: Int
}

extension TagSectionModel: IdentifiableType {
    var identity: Int {
        return uniqueID
    }
}

extension TagSectionModel: AnimatableSectionModelType {
    typealias Item = String
    
    init(original: TagSectionModel, items: [Item]) {
        self.items = items
        self.uniqueID = 0
    }
}
