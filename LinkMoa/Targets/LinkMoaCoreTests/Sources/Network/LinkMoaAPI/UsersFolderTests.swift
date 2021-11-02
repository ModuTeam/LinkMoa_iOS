//
//  UsersFolderTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/29.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class UsersFolderTests: XCTestCase {
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
    
    // MARK:- testUsersFolder
    /// 1000 -> 사용자 링크달 조회 성공
    func testUsersFolder_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.usersFolder(index: 1, params: ["page": 1, "limit": 10])
        let usersFolderResponse = try JSONDecoder().decode(
            UsersFolder.self,
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
            .map(UsersFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()

                guard response.isSuccess else {
                    XCTFail("Response is failure")
                    return
                }

                XCTAssertEqual(response.code, usersFolderResponse.code)
                XCTAssertEqual(response.message, usersFolderResponse.message)
                XCTAssertEqual(response.result, usersFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2008 -> page를 입력하세요.
    func testUsersFolder_whenPageIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.usersFolder(index: 1, params: ["limit": 10])
        let usersFolderResponse = try JSONDecoder().decode(
            UsersFolder.self,
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
            .map(UsersFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, usersFolderResponse.code)
                XCTAssertEqual(response.message, usersFolderResponse.message)
                XCTAssertEqual(response.result, usersFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2009 -> limit를 입력하세요.
    func testUsersFolder_whenLimitIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.usersFolder(index: 1, params: ["page": 1])
        let usersFolderResponse = try JSONDecoder().decode(
            UsersFolder.self,
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
            .map(UsersFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, usersFolderResponse.code)
                XCTAssertEqual(response.message, usersFolderResponse.message)
                XCTAssertEqual(response.result, usersFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testUsersFolder_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.usersFolder(index: 1, params: [:])
        
        // When
        sut.rx.request(api)
            .map(UsersFolder.self)
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
