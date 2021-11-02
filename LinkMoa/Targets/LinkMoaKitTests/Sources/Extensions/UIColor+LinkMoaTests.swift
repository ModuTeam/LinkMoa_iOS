//
//  UIColor+LinkMoaTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class UIColor_LinkMoaTests: XCTestCase {
    func testLinkMoaBlackColor() throws {
        XCTAssertEqual(UIColor.linkMoaBlackColor, UIColor(rgb: 0x485153))
    }
    
    func testLinkMoaGrayColor() throws {
        XCTAssertEqual(UIColor.linkMoaGrayColor, UIColor(rgb: 0x4B4B4B))
    }
    
    func testLinkMoaDarkBlueColor() throws {
        XCTAssertEqual(UIColor.linkMoaDarkBlueColor, UIColor(rgb: 0x364788))
    }
    
    func testLinkMoaDarkRedColor() throws {
        XCTAssertEqual(UIColor.linkMoaDarkRedColor, UIColor(rgb: 0xe4746e))
    }
    
    func testLinkMoaRedColor() throws {
        XCTAssertEqual(UIColor.linkMoaRedColor, UIColor(rgb: 0xef534b))
    }
    
    func testLinkMoaOptionBackgroundColor() throws {
        XCTAssertEqual(UIColor.linkMoaOptionBackgroundColor, UIColor(rgb: 0xeeeeee))
    }
    
    func testLinkMoaOptionTextColor() throws {
        XCTAssertEqual(UIColor.linkMoaOptionTextColor, UIColor(rgb: 0xc0c0c0))
    }

    func testLinkMoaPlaceholderColor() throws {
        XCTAssertEqual(UIColor.linkMoaPlaceholderColor, UIColor(rgb: 0xbdbdbd))
    }
    
    func testLinkMoaFolderSeletionBorderColor() throws {
        XCTAssertEqual(UIColor.linkMoaFolderSeletionBorderColor, UIColor(rgb: 0xbcbdbe))
    }

    func testLinkMoaFolderCountGrayColor() throws {
        XCTAssertEqual(UIColor.linkMoaFolderCountGrayColor, UIColor(rgb: 0x909090))
    }
    
    func testLinkMoaCategoryOptionBlackColor() throws {
        XCTAssertEqual(UIColor.linkMoaCategoryOptionBlackColor, UIColor(rgb: 0x5c5c5c))
    }
}
