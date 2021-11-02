//
//  SearchFolderTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/29.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class SearchFolderTests: XCTestCase {
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
    
    // MARK:- testSearchFolder
    /// 1000 -> (내)폴더 검색 성공
    func testSearchFolder_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchFolder(params: [
            "isMyFolders": 0,
            "limit": 10,
            "page": 1
        ])
        let searchFolderResponse = try JSONDecoder().decode(
            SearchFolder.self,
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
            .map(SearchFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.code, searchFolderResponse.code)
                XCTAssertEqual(response.message, searchFolderResponse.message)
                XCTAssertEqual(response.result, searchFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2003 -> 잘못된 기준 번호입니다
    func testSearchFolder_whenIsMyFoldersIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchFolder(params: [
            "isMyFolders": "x",
            "limit": 10,
            "page": 1
        ])
        let searchFolderResponse = try JSONDecoder().decode(
            SearchFolder.self,
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
            .map(SearchFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, searchFolderResponse.code)
                XCTAssertEqual(response.message, searchFolderResponse.message)
                XCTAssertEqual(response.result, searchFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 4000 -> userCheck DB error
    func testSearchFolder_whenLimitIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchFolder(params: [
            "isMyFolders": 0,
            "page": 1
        ])
        let searchFolderResponse = try JSONDecoder().decode(
            SearchFolder.self,
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
            .map(SearchFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, searchFolderResponse.code)
                XCTAssertEqual(response.message, searchFolderResponse.message)
                XCTAssertEqual(response.result, searchFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 4000 -> userCheck DB error
    func testSearchFolder_whenPageIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchFolder(params: [
            "isMyFolders": 0,
            "limit": 10
        ])
        let searchFolderResponse = try JSONDecoder().decode(
            SearchFolder.self,
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
            .map(SearchFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, searchFolderResponse.code)
                XCTAssertEqual(response.message, searchFolderResponse.message)
                XCTAssertEqual(response.result, searchFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testSearchFolder_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.searchFolder(params: [:])
        
        // When
        sut.rx.request(api)
            .map(SearchFolder.self)
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
