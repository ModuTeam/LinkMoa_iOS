//
//  UserInformationTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/10/05.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class UserInformationTests: XCTestCase {
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
    
    // MARK:- testUserInformation
    func testUserInformation_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.userInformation
        let userInformation = try JSONDecoder().decode(
            UserInformation.self,
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
            .map(UserInformation.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()

                guard response.isSuccess else {
                    XCTFail("Response is failure")
                    return
                }

                XCTAssertEqual(response.code, userInformation.code)
                XCTAssertEqual(response.message, userInformation.message)
                XCTAssertEqual(response.result, userInformation.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testUserInformation_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.userInformation
        
        // When
        sut.rx.request(api)
            .map(UserInformation.self)
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
