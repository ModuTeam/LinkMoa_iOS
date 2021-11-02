//
//  LMObservableTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest
import LinkMoaKit

@testable import LinkMoaKit

class LMObservableTests: XCTestCase {
    var sut: LMObservable<Int>!

    override func setUpWithError() throws {
        sut = LMObservable<Int>(0)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testValue() throws {
        // Given
        let number = 100
        
        // When
        sut.value = number
        
        // Then
        XCTAssertEqual(sut.value, number)
    }
    
    func testBind() throws {
        // Given
        let expectaion = XCTestExpectation(description: "Observer is excuted")
        let number = 100

        // When
        sut.value = number
        
        sut.bind { value in
            expectaion.fulfill()
            XCTAssertEqual(value, number)
        }
        
        // Then
        wait(for: [expectaion], timeout: 5)
    }
}
