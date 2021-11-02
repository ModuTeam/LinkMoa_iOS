//
//  LikeTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/28.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class LikeTests: XCTestCase {
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
    
    // MARK: - testLike
    /// 1000 -> 좋아요 성공
    func testLike_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.like(index: 0)
        let likeResponse = try JSONDecoder().decode(
            LinkResponse.self,
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
            .map(LinkResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.message, likeResponse.message)
                XCTAssertEqual(response.code, likeResponse.code)
                XCTAssertEqual(response.index, response.index)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2001 -> 잘못된 폴더 번호입니다
    func testLike_whenFolderIndexIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.like(index: -1)
        let likeResponse = try JSONDecoder().decode(
            LinkResponse.self,
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
            .map(LinkResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.message, likeResponse.message)
                XCTAssertEqual(response.code, likeResponse.code)
                XCTAssertEqual(response.index, response.index)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testLike_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.like(index: -1)
        
        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(LinkResponse.self)
            .subscribe(onSuccess: { response in
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
