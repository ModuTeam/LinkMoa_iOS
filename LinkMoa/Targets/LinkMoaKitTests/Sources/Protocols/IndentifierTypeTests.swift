//
//  IndentifierTypeTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class IndentifierTypeTests: XCTestCase {
    class Sut: Reusable {}
    
    func testCellIdentifier() throws {
        XCTAssertEqual(Sut.identifier, String(describing: IndentifierTypeTests.Sut.self))
    }
    
    func testViewIdentifier() throws {
        XCTAssertEqual(Sut.viewIdentifier, String(describing: IndentifierTypeTests.Sut.self))
    }
}
