//
//  LinkSectionModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/06/26.
//

import Foundation
import LinkMoaCore

import RxCocoa
import RxDataSources
import RxSwift

struct LinkSectionData {
    var items: [Item]
    var uniqueID: Int
}

extension LinkSectionData: IdentifiableType {
    var identity: Int {
        return uniqueID
    }
}

extension LinkSectionData: AnimatableSectionModelType {
    typealias Item = FolderDetail.Link
    
    init(original: LinkSectionData, items: [Item]) {
        self.items = items
        self.uniqueID = 0
    }
}
