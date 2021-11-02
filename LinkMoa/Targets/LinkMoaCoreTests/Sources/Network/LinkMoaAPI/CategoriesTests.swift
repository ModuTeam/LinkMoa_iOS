//
//  CategoriesTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/10/05.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class CategoriesTests: XCTestCase {
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
    
    // MARK:- testCategories
    /// 1000 -> 카테고리목록 조회 성공
    func testCategories_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categories
        let categoryResponse = try JSONDecoder().decode(
            CategoryInfo.self.self,
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
            .map(CategoryInfo.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()

                guard response.isSuccess else {
                    XCTFail("Response is failure")
                    return
                }

                XCTAssertEqual(response.code, categoryResponse.code)
                XCTAssertEqual(response.message, categoryResponse.message)
                XCTAssertEqual(response.result, categoryResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testCategories_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.categories
        
        // When
        sut.rx.request(api)
            .map(CategoryInfo.self)
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
