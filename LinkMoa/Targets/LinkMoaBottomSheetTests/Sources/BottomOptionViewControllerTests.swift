//
//  BottomOptionViewControllerTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/11/01.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaBottomSheet

class BottomOptionViewControllerTests: XCTestCase {
    
    var sut: ButtonOptionViewController!

    override func setUpWithError() throws {
        sut = ButtonOptionViewController.storyboardInstance()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testActionCounts_whenViewDidLoad() throws {
        // Given
        let actions = ["A", "B", "C"]
        sut.actions = actions
        
        // When
        sut.loadViewIfNeeded()
        let mirror = Mirror(reflecting: sut!)
        let editTableView = try XCTUnwrap(mirror.descendant("editTableView") as? UITableView)
        
        // then
        XCTAssertEqual(editTableView.numberOfRows(inSection: 0), actions.count)
    }
    
    func testActions_whenViewDidLoad() throws {
        // Given
        let actions = ["A", "B", "C"]
        sut.actions = actions
        
        // When
        sut.loadViewIfNeeded()
        var cellTitles: [String?] = []
        
        for index in 0..<3 {
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = sut?.tableView(sut.editTableView, cellForRowAt: indexPath),
               let editBottomCell = cell as? EditBottomSheetCell {
                cellTitles.append(editBottomCell.sheetNameLabel?.text)
            }
        }
        
        // Then
        XCTAssertEqual(actions, cellTitles)
    }
    
    func testHandlers_whenCellClicked() throws {
        // Given
        var clickedCount = 0
        let clickAction = { (_: Any?) in
            clickedCount += 1
        }
        
        sut.actions = ["A", "B", "C"]
        sut.handlers = Array(repeating: clickAction, count: 3)
        
        // When
        sut.loadViewIfNeeded()
        
        for index in 0..<3 {
            let indexPath = IndexPath(row: index, section: 0)
            sut?.tableView(sut.editTableView, didSelectRowAt: indexPath)
        }
        
        // Then
        XCTAssertEqual(clickedCount, 3)
    }
}
