//
//  LinkMoaLogTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class LinkMoaLogTests: XCTestCase {
    func testDEBUG_LOG() throws {
        let message = "hi"
        let file = #file.split(separator: "/").last ?? ""
        let function = #function.split(separator: "(").first ?? ""
        let log = "🥺[\(file)] \(function) (\(#line + 1)): \(message)"
        XCTAssertEqual(DEBUG_LOG(message), log)
    }
    
    func testERROR_LOG() throws {
        let message = "error"
        let file = #file.split(separator: "/").last ?? ""
        let function = #function.split(separator: "(").first ?? ""
        let log = "😡[\(file)] \(function) (\(#line + 1)): \(message)"
        XCTAssertEqual(ERROR_LOG(message), log)
    }
}
