//
//  GoogleSign.swift
//  LinkMoaKit
//
//  Created by won heo on 2021/09/14.
//  Copyright © 2021 com.modu. All rights reserved.
//

import Foundation
import LinkMoaCore

import GoogleSignIn

final class GoogleSign {
    static let shared = GoogleSign()
    static let clientID = PrivateKey.googleClientID
    private init() {}
    
    let signInConfig = GIDConfiguration.init(clientID: GoogleSign.clientID)
}
