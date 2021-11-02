//
//  AddLinkTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/24.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class AddLinkTests: XCTestCase {
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
    
    // MARK: - testAddLink
    /// 1000 -> 링크 추가 성공
    func testAddLink_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: 0, params: [
            "linkName": "test",
            "linkUrl": "https://www.naver.com"
        ])
        let linkResponse = try JSONDecoder().decode(
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
            .map(FolderResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertTrue(response.isSuccess)
                XCTAssertEqual(response.code, linkResponse.code)
                XCTAssertEqual(response.message, linkResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2001 -> 링크 이름을 입력해주세요
    func testAddLink_whenLinkNameIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: 0, params: [
            "linkName": "",
            "linkUrl": "https://www.naver.com"
        ])
        let linkResponse = try JSONDecoder().decode(
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
            .map(FolderResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, linkResponse.code)
                XCTAssertEqual(response.message, linkResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2002 -> 링크 이름은 40자 이하로 입력해주세요
    func testAddLink_whenLinkNameCountOverForty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: 0, params: [
            "linkName": String(repeating: "x", count: 41),
            "linkUrl": "https://www.naver.com"
        ])
        let linkResponse = try JSONDecoder().decode(
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
            .map(FolderResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, linkResponse.code)
                XCTAssertEqual(response.message, linkResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2003 -> 링크가 올바른 링크 형식이 아닙니다
    func testAddLink_whenLinkURLIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: 0, params: [
            "linkName": "test",
            "linkUrl": "www.test.co.m"
        ])
        let linkResponse = try JSONDecoder().decode(
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
            .map(FolderResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, linkResponse.code)
                XCTAssertEqual(response.message, linkResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2003 -> 이미지링크가 올바른 링크 형식이 아닙니다
    func testAddLink_whenImageURLIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: 0, params: [
            "linkName": "test",
            "linkUrl": "http://www.naver.com",
            "linkImageUrl": "www.image.co.m"
        ])
        let linkResponse = try JSONDecoder().decode(
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
            .map(FolderResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, linkResponse.code)
                XCTAssertEqual(response.message, linkResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2005 -> 파비콘 링크가 올바른 링크 형식이 아닙니다
    func testAddLink_whenFaviconURLIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: 0, params: [
            "linkName": "test",
            "linkUrl": "http://www.naver.com",
            "linkImageUrl": "http://www.naver.com/image",
            "linkFaviconUrl": "www.image.co.m"
        ])
        let linkResponse = try JSONDecoder().decode(
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
            .map(FolderResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, linkResponse.code)
                XCTAssertEqual(response.message, linkResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2006 -> 잘못된 폴더 번호입니다
    /// 2007 -> 선택한 폴더가 존재하지 않습니다
    /// 2007 인 경우만 test
    func testAddLink_whenFolderIndexIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: -1, params: [
            "linkName": "test",
            "linkUrl": "http://www.naver.com",
            "linkImageUrl": "http://www.naver.com/image",
            "linkFaviconUrl": "http://www.naver.com/favicon.ico"
        ])
        let linkResponse = try JSONDecoder().decode(
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
            .map(FolderResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, linkResponse.code)
                XCTAssertEqual(response.message, linkResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testAddLink_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.addLink(index: 0, params: [:])
        
        // When
        sut.rx.request(api)
            .map(FolderResponse.self)
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
