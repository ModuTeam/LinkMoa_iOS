//
//  MyFolderListTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/23.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

class MyFolderListTests: XCTestCase {
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

    // MARK:- testMyFolderList
    func testMyFolderList_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.myFolderList(index: 0, filter: 0)
        let folderListResponse = try JSONDecoder().decode(
            FolderList.self,
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
            .map(FolderList.self)
            .subscribe(onSuccess: { response in
                promise.fulfill()
                
                guard response.isSuccess else {
                    XCTFail("response is Failure")
                    return
                }
                
                XCTAssertEqual(response.code, folderListResponse.code)
                XCTAssertEqual(response.message, folderListResponse.message)
                XCTAssertEqual(response.result, folderListResponse.result)
            }, onError: { error in
                promise.fulfill()
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testMyFolderList_whenFailure() throws {
        // Given
        sut = LinkMoaAPI.errorStubbingProvider(endPointClosure: customEndpointClosure)
        let promise = XCTestExpectation(description: "Subscribe is executed")
        let api = LinkMoaAPI.myFolderList(index: 0, filter: 0)
        
        // When
        sut.rx.request(api)
            .map(FolderDetail.self)
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
