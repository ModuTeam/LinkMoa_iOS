//
//  ImageAlertViewControllerTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/11/01.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaBottomSheet

class ImageAlertViewControllerTests: XCTestCase {

    var sut: ImageAlertViewController!

    override func setUpWithError() throws {
        sut = try XCTUnwrap(ImageAlertViewController.storyboardInstance())
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testRemoveFolderTitleUI_whenViewDidLoad() throws {
        // Given
        sut.succeed = .removeFolder
        
        // When
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let subTitleLabel = try XCTUnwrap(mirror.descendant("subTitleLabel") as? UILabel)
        
        // Then
        XCTAssertEqual(titleLabel.text, "나의 가리비가 완전히 사라졌어요!")
        XCTAssertEqual(subTitleLabel.text, "삭제가 완료되었습니다.")
    }

    func testEditNicknameTitleUI_whenViewDidLoad() throws {
        // Given
        sut.succeed = .editNickname
        
        // When
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let subTitleLabel = try XCTUnwrap(mirror.descendant("subTitleLabel") as? UILabel)
        
        // Then
        XCTAssertEqual(titleLabel.text, "나의 닉네임을 변경했어요.")
        XCTAssertEqual(subTitleLabel.text, "저장이 완료되었습니다.")
    }
    
    func testReportFolderTitleUI_whenViewDidLoad() throws {
        // Given
        sut.succeed = .reportFolder
        
        // When
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let subTitleLabel = try XCTUnwrap(mirror.descendant("subTitleLabel") as? UILabel)
        
        // Then
        XCTAssertEqual(titleLabel.text, "링크달 신고를 완료했어요!")
        XCTAssertEqual(subTitleLabel.text, "심사일까지 일주일이 소요될 수 있습니다.")
    }
    
    func testSaveFolderTitleUI_whenViewDidLoad() throws {
        // Given
        sut.succeed = .saveFolder
        
        // When
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let subTitleLabel = try XCTUnwrap(mirror.descendant("subTitleLabel") as? UILabel)
        
        // Then
        XCTAssertEqual(titleLabel.text, "나의 가리비를 안전하게 보관했어요!")
        XCTAssertEqual(subTitleLabel.text, "저장이 완료되었습니다.")
    }
    
    func testCompletion_whenDismiss() throws {
        // Given
        var isClicked = false

        sut.completion = { 
            isClicked.toggle()
        }
        
        // When
        sut.loadViewIfNeeded()
        sut.dismissButtonTapped()
        
        // Then
        XCTAssertTrue(isClicked)
    }
}
