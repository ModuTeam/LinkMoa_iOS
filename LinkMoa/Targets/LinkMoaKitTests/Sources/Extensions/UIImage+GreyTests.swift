//
//  UIImage+GreyTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class UIImage_GreyTests: XCTestCase {
    func testGreyScale() throws {
        let image = UIImage(systemName: "gear")
        XCTAssertNotNil(image?.greyScale)
    }
    
    func testGeryScale_whenImageIsEmpty() throws {
        let image = UIImage()
        XCTAssertNil(image.greyScale)
    }
}
