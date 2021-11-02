//
//  CategoryDetailTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/29.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class CategoryDetailTests: XCTestCase {
    var sut: MoyaProvider<LinkMoaAPI>!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        sut = MoyaProvider<LinkMoaAPI>(stubClosure: MoyaProvider.immediatelyStub)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
    }
    
    // CategoryInfo
    
    // MARK: - testCategoryDetail
    /// 1000 -> 카테고리별 링크달 조회 성공
    func testCategoryDetail_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 1, subIndex: 1, params: [
            "limit": 10,
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                XCTAssertEqual(response.result?.count, categoryInfoResponse.result?.count)
                XCTAssertEqual(response.result?.list, categoryInfoResponse.result?.list)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2002 -> categoryIdx는 1-5 사이의 정수입니다.
    func testCategoryDetail_whenCategoryIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 0, subIndex: 0, params: [
            "limit": 10,
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2004 -> categoryIdx가 1일때 detailCategoryIdx는 1~10을 입력하세요.
    func testCategoryDetail_whenCategoryIsOne_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 1, subIndex: 11, params: [
            "limit": 10,
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2005 -> categoryIdx가 2일때 detailCategoryIdx는 11~18을 입력하세요.
    func testCategoryDetail_whenCategoryIsTwo_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 2, subIndex: 19, params: [
            "limit": 10,
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2006 -> categoryIdx가 3일때 detailCategoryIdx는 19~25을 입력하세요.
    func testCategoryDetail_whenCategoryIsThree_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 3, subIndex: 26, params: [
            "limit": 10,
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2007 -> categoryIdx가 4일때 detailCategoryIdx는 26~30을 입력하세요.
    func testCategoryDetail_whenCategoryIsFour_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 4, subIndex: 31, params: [
            "limit": 10,
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2008 -> categoryIdx가 5일때 detailCategoryIdx는 0을 입력하세요.
    func testCategoryDetail_whenCategoryIsFive_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 5, subIndex: 1, params: [
            "limit": 10,
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2012 -> limit를 입력하세요.
    func testCategoryDetail_whenLimitIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 1, subIndex: 1, params: [
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2013 -> lastFolderIdx를 입력하세요.
    func testCategoryDetail_whenLastFolderIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 1, subIndex: 1, params: [
            "lastFolderIdx": 10
        ])
        let categoryInfoResponse = try JSONDecoder().decode(
            CategoryDetailFolder.self,
            from: api.sampleData
        )
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, categoryInfoResponse.code)
                XCTAssertEqual(response.message, categoryInfoResponse.message)
                promise.fulfill()
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testCategoryDetail_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categoryDetail(mainIndex: 0, subIndex: 0, params: [:])
        
        // When
        sut.rx.request(api)
            .map(CategoryDetailFolder.self)
            .subscribe(onSuccess: { _ in
                promise.fulfill()
                XCTFail("Response is not failure")
            }, onError: { error in
                promise.fulfill()
                XCTAssertEqual(error.localizedDescription, linkMoaStubError.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
}
