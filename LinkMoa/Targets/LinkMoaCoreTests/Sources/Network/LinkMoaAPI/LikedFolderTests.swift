//
//  LikedFolderTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/28.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class LikedFolderTests: XCTestCase {
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

    // MARK: - testLikedFolderTests
    /// 1000 -> 좋아요한 폴더 조회 성공
    func testLikedFolder_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is excuted")
        let api = LinkMoaAPI.likedFolder(params: [:])
        let likedFolderResponse = try JSONDecoder().decode(
            LikedFolder.self,
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
            .map(LikedFolder.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.message, likedFolderResponse.message)
                XCTAssertEqual(response.code, likedFolderResponse.code)
                XCTAssertEqual(response.result, likedFolderResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testLikedFolder_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.likedFolder(params: [:])

        // When
        sut.rx.request(api)
            .do(onSuccess: { response in
                guard 200 ..< 300 ~= response.statusCode else {
                    XCTFail("Status code was \(response.statusCode), but expected 2xx")
                    return
                }
            })
            .map(LikedFolder.self)
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
