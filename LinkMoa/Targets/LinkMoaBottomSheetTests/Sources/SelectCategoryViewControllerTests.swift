//
//  SelectCategoryViewControllerTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/11/01.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaBottomSheet

class SelectCategoryViewControllerTests: XCTestCase {
    
    var sut: SelectCategoryViewController!

    override func setUpWithError() throws {
        sut = SelectCategoryViewController.storyboardInstance()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSelection_whenCategorySelected() throws {
        // Given
        let numbers = [1, 2, 3]
        let categories = ["A", "B", "C"]
        
        var selectedNumber = 0
        var selectedCategory = ""
        
        sut.categoryNumbers = numbers
        sut.categories = categories
        sut.selection = { (title: String, number: Int) in
            selectedCategory = title
            selectedNumber = number
        }
        
        // When
        sut.loadViewIfNeeded()
        let indexPath = IndexPath(item: 1, section: 0)
        sut.collectionView(sut.categoryCollectionView, didSelectItemAt: indexPath)
        
        // Then
        XCTAssertEqual(selectedNumber, 2)
        XCTAssertEqual(selectedCategory, "B")
    }
    
    func testCategoryCount_whenViewDidLoad() throws {
        // Given
        let numbers = [1, 2, 3]
        let categories = ["A", "B", "C"]

        sut.categoryNumbers = numbers
        sut.categories = categories
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertEqual(
            sut.collectionView(sut.categoryCollectionView, numberOfItemsInSection: 0),
            categories.count
        )
    }
    
    func testCompletion_whenDismissButtonTapped() throws {
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
