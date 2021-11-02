//
//  String+RegexTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class String_RegexTests: XCTestCase {
    func testIsValidHttps_whenURLIsValid() throws {
        XCTAssertTrue("http://www.google.com".isValidHttps())
    }
    
    func testIsValidHttps_whenURLIsNotValid() throws {
        XCTAssertFalse("http:/www.fail..com".isValidHttps())
    }
}
