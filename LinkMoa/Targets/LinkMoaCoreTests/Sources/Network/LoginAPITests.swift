//
//  LoginAPITests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/23.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//


import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

let LoginStubError = MoyaError.statusCode(Response(statusCode: 400, data: Data())) as NSError

class LoginAPITests: XCTestCase {
    var sut: MoyaProvider<LoginAPI>!
    var disposeBag: DisposeBag!
    
    let customEndpointClosure = { (target: LoginAPI) -> Endpoint in
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkError(LoginStubError) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
    
    override func setUpWithError() throws {
        sut = MoyaProvider<LoginAPI>(stubClosure: MoyaProvider.immediatelyStub)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
    }
    
    func testProvider() throws {
        XCTAssertTrue((LoginAPI.provider as Any) is MoyaProvider<LoginAPI>)
    }

    func testAppleLogin_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LoginAPI.appleLogin(authCode: "test-auth-code")
        let appleLoginResponse = try JSONDecoder().decode(
            AppleLogin.Response.self,
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
            .map(AppleLogin.Response.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.message, appleLoginResponse.message)
                XCTAssertEqual(response.code, appleLoginResponse.code)
                XCTAssertEqual(response.result?.jwt, appleLoginResponse.result?.jwt)
                XCTAssertEqual(response.result?.member, appleLoginResponse.result?.member)
                XCTAssertEqual(response.result?.userIndex, appleLoginResponse.result?.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testAppleLogin_whenFailure() throws {
        // Given
        sut = LoginAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LoginAPI.appleLogin(authCode: "test-auth-code")
        
        // When
        sut.rx.request(api)
            .map(AppleLogin.Response.self)
            .subscribe(onSuccess: { _ in
                promise.fulfill()
                XCTFail("Response is not failure")
            }, onError: { error in
                promise.fulfill()
                XCTAssertEqual(error.localizedDescription, LoginStubError.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testGoogleLogin_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LoginAPI.googleLogin(accessToken: "test-access-token")
        let googleLoginResponse = try JSONDecoder().decode(
            GoogleLogin.Response.self,
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
            .map(GoogleLogin.Response.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.code, googleLoginResponse.code)
                XCTAssertEqual(response.message, googleLoginResponse.message)
                XCTAssertEqual(response.result?.jwt, googleLoginResponse.result?.jwt)
                XCTAssertEqual(response.result?.member, googleLoginResponse.result?.member)
                XCTAssertEqual(response.result?.userIndex, googleLoginResponse.result?.userIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testGoogleLogin_whenFailure() throws {
        // Given
        sut = LoginAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LoginAPI.googleLogin(accessToken: "test-access-token")
        
        // When
        sut.rx.request(api)
            .map(GoogleLogin.Response.self)
            .subscribe(onSuccess: { _ in
                promise.fulfill()
                XCTFail("Response is not failure")
            }, onError: { error in
                promise.fulfill()
                XCTAssertEqual(error.localizedDescription, LoginStubError.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
}
