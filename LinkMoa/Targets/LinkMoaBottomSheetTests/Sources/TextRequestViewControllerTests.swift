//
//  TextRequestViewControllerTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/11/01.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaBottomSheet

class TextRequestViewControllerTests: XCTestCase {

    var sut: TextRequestViewController!

    override func setUpWithError() throws {
        sut = TextRequestViewController.storyboardInstance()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testUI_whenViewDidLoad_withEditNickname() throws {
        // Given
        sut.removeRequest = .editNickname
        sut.name = "nickname"
        
        // When
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let folderNameTextField = try XCTUnwrap(mirror.descendant("folderNameTextField") as? UITextField)
        let titleLabel = try XCTUnwrap(mirror.descendant("titleLabel") as? UILabel)
        let subTitleLabel = try XCTUnwrap(mirror.descendant("subTitleLabel") as? UILabel)
        let buttonLabel = try XCTUnwrap(mirror.descendant("buttonLabel") as? UILabel)
        
        // Then
        XCTAssertEqual(folderNameTextField.text, "nickname")
        XCTAssertEqual(titleLabel.text, "닉네임 변경")
        XCTAssertEqual(subTitleLabel.text, "변경하려는 닉네임을 입력해주세요.")
        XCTAssertEqual(buttonLabel.text, "닉네임 변경")
    }
    
    func testUI_whenViewDidLoad_withRemoveFolder() throws {
        // Given
        sut.removeRequest = .removeFolder
        sut.name = "folder"
        
        // When
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let subTitleLabel = try XCTUnwrap(mirror.descendant("subTitleLabel") as? UILabel)
        
        // Then
        XCTAssertEqual(subTitleLabel.text, "삭제를 원하시면 folder을 입력하세요.")
    }
    
    func testRemoveFolderCompletion_whenDeleteButtonViewTapped_withEqaulFolderName() throws {
        // Given
        var isExcuted = false
        sut.removeRequest = .removeFolder
        sut.name = "testFolderName"
        sut.completion = { (_: Any?) in
            isExcuted.toggle()
        }
        
        sut.loadViewIfNeeded()
        sut.folderNameTextField.text = "testFolderName"
        
        // When
        sut.deleteButtonViewTapped()
        
        // Then
        XCTAssertTrue(isExcuted)
    }
    
    func testRemoveFolderCompletion_whenDeleteButtonViewTapped_withNotEqaulFolderName() throws {
        // Given
        var isExcuted = false
        sut.removeRequest = .removeFolder
        sut.name = "testFolderName"
        sut.completion = { (_: Any?) in
            isExcuted.toggle()
        }
        
        sut.loadViewIfNeeded()
        sut.folderNameTextField.text = "testFolder-"
        
        // When
        sut.deleteButtonViewTapped()
        
        // Then
        XCTAssertFalse(isExcuted)
    }
    
    func testEditNicknameCompletion_whenDeleteButtonViewTapped_withValidNickname() throws {
        // Given
        var isExcuted = false
        sut.removeRequest = .editNickname
        sut.name = "old"
        sut.completion = { (_: Any?) in
            isExcuted.toggle()
        }
        
        sut.loadViewIfNeeded()
        sut.folderNameTextField.text = "new"
        
        // When
        sut.deleteButtonViewTapped()
        
        // Then
        XCTAssertTrue(isExcuted)
    }
    
    func testEditNicknameCompletion_whenDeleteButtonViewTapped_withInValidNickname() throws {
        // Given
        var isExcuted = false
        sut.removeRequest = .editNickname
        sut.name = "old"
        sut.completion = { (_: Any?) in
            isExcuted.toggle()
        }
        
        sut.loadViewIfNeeded()
        sut.folderNameTextField.text = "old"
        
        // When
        sut.deleteButtonViewTapped()
        
        // Then
        XCTAssertFalse(isExcuted)
    }
}
