//
//  EditFolderTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/23.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class EditFolderTests: XCTestCase {
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

    // MARK: - testEditFolder
    /// 1000 -> 폴더 수정 성공
    func testEditFolder_whenSucceed_withPrivateFolderType() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "private"
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 1000 -> 폴더 수정 성공
    func testEditFolder_whenSucceed_withPublicFolderType() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "public",
            "hashTagList": ["tag"],
            "categoryIdx": 2,
            "detailCategoryIdx": 10
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2000 -> folderName을 입력하세요.
    func testEditFolder_whenFolderNameIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "",
            "folderType": "private"
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2001 -> folderName은 30자 이하 문자열입니다.
    func testEditFolder_whenFolderNameIsBiggerThanThirty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": String(repeating: "x", count: 31),
            "folderType": "private"
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2002 -> hashTag는 20자 이하 문자열입니다.
    func testEditFolder_whenTagNameCountIsBiggerThanTwenty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "private",
            "hashTagList" : [String(repeating: "x", count: 21)]
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2003 -> folderType을 입력하세요.
    func testEditFolder_whenFolderTypeIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": ""
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2004 -> folderType은 public 아니면 private입니다.
    func testEditFolder_whenFolderTypeIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "x"
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2005 -> categoryIdx을 입력하세요.
    func testEditFolder_whenCategoryIdxIsEmpty_withPublicFolderType() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "public"
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2006 -> categoryIdx는 1-5 사이의 정수입니다.
    func testEditFolder_whenCategoryIdxIsBiggerThanFive() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "public",
            "categoryIdx": 6
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2007 -> detailCategoryIdx를 입력하세요.
    func testEditFolder_whenDetailCategoryIdxIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "public",
            "categoryIdx": 5
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2008 -> detailCategoryIdx는 1-30 사이의 정수입니다.
    func testEditFolder_whenDetailCategoryIdxIsBiggerThanThirty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [
            "folderName": "test",
            "folderType": "public",
            "categoryIdx": 5,
            "detailCategoryIdx": 31
        ])
        let folderResponse = try JSONDecoder().decode(
            FolderResponse.self,
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
                XCTAssertEqual(response.code, folderResponse.code)
                XCTAssertEqual(response.message, folderResponse.message)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testEditFolder_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editFolder(index: 0, params: [:])
        
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
