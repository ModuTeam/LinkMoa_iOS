//
//  CustomAlertTest.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/11/01.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaBottomSheet

class CustomAlertTest: XCTestCase {
    
    var window: UIWindow!
    var sut: MockUIViewController!

    override func setUpWithError() throws {
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sut = MockUIViewController()
        window.rootViewController = sut
        window.makeKeyAndVisible()
    }

    override func tearDownWithError() throws {
        sut = nil
        window = nil
    }
    
    func testPresentImageAlertView() throws {
        // Given
        sut.loadViewIfNeeded()
        
        // When
        sut.presentImageAlertView()
        RunLoop.current.run(until: Date())
        
        // then
        XCTAssertTrue(sut.presentedViewController is ImageAlertViewController)
    }
}
