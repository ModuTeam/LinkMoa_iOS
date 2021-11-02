//
//  EditUserInformationTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/27.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class EditUserInformationTests: XCTestCase {
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
    
    // MARK:- testEditUserInformation
    /// 1000 -> 유저 정보 추가 성공
    func testEditUserInformation_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: [
                "userNickname": "test",
                "userProfileImgUrl": "https://www.linkmoa.image",
                "category": 1,
                "userDetailCategoryIdx": 1
            ]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("Response is failure")
                    return
                }
                
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2003 -> userNickname은 30자 이하로 입력해주세요.
    func testEditUserInformation_whenNameOverThirty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userNickname": String(repeating: "x", count: 31)]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2004 -> 프로필 이미지 링크가 올바른 링크 형식이 아닙니다
    func testEditUserInformation_whenProfileURLIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userProfileImgUrl": "www..image"]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2006 -> categoryIdx는 1-5 사이의 정수입니다.
    func testEditUserInformation_whenCategoryIsInvalid() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userCategoryIdx": 6]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2007 -> categoryIdx가 1일때 detailCategoryIdx는 1~10을 입력하세요.
    func ttestEditUserInformation_whenCategoryIsOne_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userCategoryIdx": 1, "userDetailCategoryIdx": 11]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2008 -> categoryIdx가 2일때 detailCategoryIdx는 11~18을 입력하세요.
    func testEditUserInformation_whenCategoryIsTwo_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userCategoryIdx": 2, "userDetailCategoryIdx": 19]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2009 -> categoryIdx가 3일때 detailCategoryIdx는 19~25을 입력하세요
    func testEditUserInformation_whenCategoryIsThree_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userCategoryIdx": 3, "userDetailCategoryIdx": 26]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2010 -> categoryIdx가 4일때 detailCategoryIdx는 26~30을 입력하세요.
    func testEditUserInformation_whenCategoryIsFour_withInvalidDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userCategoryIdx": 4, "userDetailCategoryIdx": 31]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2011 -> categoryIdx가 5일때 detailCategoryIdx를 Body에 담지마세요.
    func testEditUserInformation_whenCategoryIsFive_withDetailCategory() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(
            params: ["userCategoryIdx": 5, "userDetailCategoryIdx": 1]
        )
        let userInformationResponse = try JSONDecoder().decode(
            EditUserInformationResponse.self,
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
            .map(EditUserInformationResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, userInformationResponse.code)
                XCTAssertEqual(response.message, userInformationResponse.message)
                XCTAssertEqual(response.userIndex, userInformationResponse.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testEditUserInformation_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.editUserInformation(params: [:])
        
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
