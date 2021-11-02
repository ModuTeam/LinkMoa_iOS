//
//  DefaulErrorTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class DefaultErrorTests: XCTestCase {
    func testDefaultError_whenCaseIsFlatMap() throws {
        XCTAssertEqual(DefaultError.flatmap.localizedDescription, "예상치 못한 에러가 발생했습니다.")
    }
    
    func testDefaultError_whenCaseIsNetwork() throws {
        XCTAssertEqual(DefaultError.network.localizedDescription, "서버 에러가 발생했습니다.")
    }
}
