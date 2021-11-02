//
//  UIView+RoundConersTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class UIView_RoundConersTests: XCTestCase {
    func testRoundCorners() throws {
        // Given
        let view = UIView()
        
        // When
        view.roundCorners(corners: [.allCorners], radius: 1)
        
        // Then
        XCTAssertNotNil(view.layer.mask)
    }
}
