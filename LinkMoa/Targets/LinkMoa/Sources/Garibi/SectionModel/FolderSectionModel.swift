//
//  FolderSectionModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/06/18.
//

import Foundation
import LinkMoaCore

import RxCocoa
import RxDataSources
import RxSwift

struct FolderSectionData {
    var items: [Item]
    var uniqueID: Int
}

extension FolderSectionData: IdentifiableType {
    var identity: Int {
        return uniqueID
    }
}

extension FolderSectionData: AnimatableSectionModelType {
    typealias Item = FolderList.Result
    
    init(original: FolderSectionData, items: [Item]) {
        self.items = items
        self.uniqueID = 0
    }
}
