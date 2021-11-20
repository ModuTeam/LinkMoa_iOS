//
//  TokenStorageTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/11/20.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest
import LinkMoaCore

@testable import LinkMoaCore

class TokenStorageTests: XCTestCase {
    var mock: MockUserDefaults!
    var sut: TokenStorage<String>!
    
    override func setUpWithError() throws {
        mock = MockUserDefaults()
        sut = TokenStorage(userDefaults: mock, key: "test")
    }

    override func tearDownWithError() throws {
        mock = nil
        sut = nil
    }

    func testWrappedValue_whenValueIsStored() throws {
        sut.wrappedValue = "value"
        XCTAssertEqual(sut.wrappedValue, "value")
    }
    
    func testWrappedValue_whenValueIsChanged() throws {
        sut.wrappedValue = "value"
        XCTAssertEqual(sut.wrappedValue, "value")
        
        sut.wrappedValue = "changed"
        XCTAssertNotEqual(sut.wrappedValue, "value")
    }
    
    func testWrappedValue_whenValueIsEmpty() throws {
        XCTAssertNil(sut.wrappedValue)
    }
}
