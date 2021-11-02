//
//  ReconfirmViewControllerTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/11/01.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaBottomSheet

class ReconfirmViewControllerTests: XCTestCase {
    
    var sut: ReconfirmViewController!

    override func setUpWithError() throws {
        sut = ReconfirmViewController.storyboardInstance()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testReportFolderUI_whenViewDidLoad() throws {
        // When
        sut.reconfirm = .reportFolder
        
        // Given
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let reportLabel = try XCTUnwrap(mirror.descendant("reportLabel") as? UILabel)
        let buttonLabel = try XCTUnwrap(mirror.descendant("buttonLabel") as? UILabel)

        // Then
        XCTAssertEqual(titleLabel.text, "신고하기")
        XCTAssertEqual(reportLabel.text, "링크달을 신고하시겠습니까?")
        XCTAssertEqual(buttonLabel.text, "신고하기")
    }

    func testLogoutUI_whenViewDidLoad() throws {
        // When
        sut.reconfirm = .logout
        
        // Given
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let reportLabel = try XCTUnwrap(mirror.descendant("reportLabel") as? UILabel)
        let buttonLabel = try XCTUnwrap(mirror.descendant("buttonLabel") as? UILabel)

        // Then
        XCTAssertEqual(titleLabel.text, "로그아웃")
        XCTAssertEqual(reportLabel.text, "로그아웃 하시겠습니까?")
        XCTAssertEqual(buttonLabel.text, "로그아웃")
    }
    
    func testDeleteAccountUI_whenViewDidLoad() throws {
        // When
        sut.reconfirm = .deleteAccount
        
        // Given
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let reportLabel = try XCTUnwrap(mirror.descendant("reportLabel") as? UILabel)
        let buttonLabel = try XCTUnwrap(mirror.descendant("buttonLabel") as? UILabel)

        // Then
        XCTAssertEqual(titleLabel.text, "탈퇴하기")
        XCTAssertEqual(reportLabel.text, "탈퇴 후에는 복구가 불가능하며 작성한 모든 데이터를 삭제하거나 수정할 수 없습니다.")
        XCTAssertEqual(buttonLabel.text, "동의 후 탈퇴하기")
    }
    
    func testCompletion_whenReportButtonViewTapped() throws {
        // Given
        var isClicked = false

        sut.completion = {
            isClicked.toggle()
        }
        
        // When
        sut.loadViewIfNeeded()
        sut.reportButtonViewTapped()
        
        // Then
        XCTAssertTrue(isClicked)
    }
}
