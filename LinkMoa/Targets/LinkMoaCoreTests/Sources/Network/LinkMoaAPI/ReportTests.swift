//
//  ReportTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/10/05.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class ReportTests: XCTestCase {
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
    
    // MARK:- testReport
    /// 1000 -> 신고하기 성공
    func testReport_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.report(params: ["folderIdx": 1])
        let reportResponse = try JSONDecoder().decode(
            ReportResponse.self,
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
            .map(ReportResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()

                guard response.isSuccess else {
                    XCTFail("Response is failure")
                    return
                }

                XCTAssertEqual(response.code, reportResponse.code)
                XCTAssertEqual(response.message, reportResponse.message)
                XCTAssertEqual(response.reportIndex, reportResponse.reportIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2000 -> folderIdx를 입력하세요.
    func testReport_whenFolderIndexIsEmpty() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.report(params: [:])
        let reportResponse = try JSONDecoder().decode(
            ReportResponse.self,
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
            .map(ReportResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, reportResponse.code)
                XCTAssertEqual(response.message, reportResponse.message)
                XCTAssertEqual(response.reportIndex, reportResponse.reportIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 2000 -> folderIdx를 입력하세요.
    func testReport_whenFolderIndexIsNotInt() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.report(params: ["folderIdx": "x"])
        let reportResponse = try JSONDecoder().decode(
            ReportResponse.self,
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
            .map(ReportResponse.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                XCTAssertFalse(response.isSuccess)
                XCTAssertEqual(response.code, reportResponse.code)
                XCTAssertEqual(response.message, reportResponse.message)
                XCTAssertEqual(response.reportIndex, reportResponse.reportIndex)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testReport_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.report(params: [:])
        
        // When
        sut.rx.request(api)
            .map(ReportResponse.self)
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
