//
//  SearchLinkTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/30.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class SearchLinkTests: XCTestCase {
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
    
    // MARK:- testSearchLink
    /// 1000 -> (내)링크 검색 성공
    func testSearchLink_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchLink(params: [
            "page": 1,
            "limit": 10,
            "isMyFolders": 0
        ])
        let searchLinkResponse = try JSONDecoder().decode(
            SearchLink.self,
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
            .map(SearchLink.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertTrue(response.isSuccess)
                XCTAssertEqual(response.code, searchLinkResponse.code)
                XCTAssertEqual(response.message, searchLinkResponse.message)
                XCTAssertEqual(response.result, searchLinkResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2011 -> page를 입력하세요
    func testSearchLink_whenPageIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchLink(params: [
            "limit": 10,
            "isMyFolders": 0
        ])
        let searchLinkResponse = try JSONDecoder().decode(
            SearchLink.self,
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
            .map(SearchLink.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, searchLinkResponse.code)
                XCTAssertEqual(response.message, searchLinkResponse.message)
                XCTAssertEqual(response.result, searchLinkResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2012 -> limit를 입력하세요
    func testSearchLink_whenLimitIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchLink(params: [
            "page": 1,
            "isMyFolders": 0
        ])
        let searchLinkResponse = try JSONDecoder().decode(
            SearchLink.self,
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
            .map(SearchLink.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, searchLinkResponse.code)
                XCTAssertEqual(response.message, searchLinkResponse.message)
                XCTAssertEqual(response.result, searchLinkResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2003 -> 잘못된 기준 번호입니다
    func testSearchLink_whenLimitIsNotInt() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchLink(params: [
            "page": 1,
            "limit": 10,
            "isMyFolders": "x"
        ])
        let searchLinkResponse = try JSONDecoder().decode(
            SearchLink.self,
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
            .map(SearchLink.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, searchLinkResponse.code)
                XCTAssertEqual(response.message, searchLinkResponse.message)
                XCTAssertEqual(response.result, searchLinkResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2003 -> 잘못된 기준 번호입니다
    func testSearchLink_whenLimitIsInvalidNumber() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchLink(params: [
            "page": 1,
            "limit": 10,
            "isMyFolders": -1
        ])
        let searchLinkResponse = try JSONDecoder().decode(
            SearchLink.self,
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
            .map(SearchLink.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, searchLinkResponse.code)
                XCTAssertEqual(response.message, searchLinkResponse.message)
                XCTAssertEqual(response.result, searchLinkResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testSearchLink_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchLink(params: [:])
        
        // When
        sut.rx.request(api)
            .map(SearchLink.self)
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
