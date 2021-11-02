//
//  RegisterDataManager.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/12.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation

final class RegisterDataManager {
    var nickname = ""
    var categoryIndex = -1
    var detailCategoryIndex = -1
    
    var trimmedNickname: String {
        return nickname.trimmingCharacters(in: .whitespaces)
    }
}
