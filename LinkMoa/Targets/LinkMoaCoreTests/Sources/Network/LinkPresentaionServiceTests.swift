//
//  LinkPresentaionServiceTests.swift
//  LinkMoaTests
//
//  Created by won heo on 2021/08/30.
//

import XCTest

import Moya
import RxSwift

@testable import LinkMoaCore

let naverResponseFileName = "naverResponse.txt"
let giggleResponseFileName = "giggleResponse.txt"

class LinkPresentaionServiceTests: XCTestCase {
    var sut: LinkPresentaionService!

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        let mockURLSession = URLSession(configuration: config)
        let mockMetadataProvider = MockLPMetadataProvider()
        sut = LinkPresentaionService(urlSession: mockURLSession, metadataProvider: mockMetadataProvider)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - testFetchMetaDataURL
    /// 성공
    func testFetchMetaDataURL_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Response is Succeed")
        let urlString = "https://www.naver.com/"
        let path = try TestUtil.path(for: naverResponseFileName)
        let responseString = try String(contentsOfFile: path)
        
        MockURLProtocol.successMock[urlString] = Data(responseString.utf8)
        
        // When
        sut.fetchMetaDataURL(targetURLString: urlString) { webMetaData in
            promise.fulfill()
            XCTAssertEqual(webMetaData.title, "네이버")
            XCTAssertEqual(
                webMetaData.faviconURLString,
                LinkPresentaionService.googleFaviconURLString + urlString
            )
            XCTAssertEqual(
                webMetaData.webPreviewURLString,
                "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png"
            )
        }
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// PreviewImage 가 존재하지 않을 때
    func testFetchMetaDataURL_whenSucceed_withEmptyPreviewImage() throws {
        // Given
        let promise = XCTestExpectation(description: "Response is Succeed")
        let urlString = "https://gigglehd.com/gg/"
        let path = try TestUtil.path(for: giggleResponseFileName)
        let responseString = try String(contentsOfFile: path)
        
        MockURLProtocol.successMock[urlString] = Data(responseString.utf8)
        
        // When
        sut.fetchMetaDataURL(targetURLString: urlString) { webMetaData in
            promise.fulfill()
            XCTAssertEqual(webMetaData.title, "기글하드웨어 - 뉴스는 기글")
            XCTAssertEqual(
                webMetaData.faviconURLString,
                LinkPresentaionService.googleFaviconURLString + urlString
            )
            XCTAssertNil(webMetaData.webPreviewURLString)
        }
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// 네트워크 요청이 실패할 때
    /// 웹에 메타데이터가 존재하지않을 수 있기 때문에,
    /// 요청에 실패해도 Error 를 방출하지 않도록 설계함
    /// 따라서 모든 값이 nil 이면 network 실패했다고 판단할 수 있음
    func testFetchMetaDataURL_whenFailure() throws {
        // Given
        let promise = XCTestExpectation(description: "Response is Succeed")
        let urlString = "https://failure.com"
        MockURLProtocol.failureMock[urlString] = LinkError.urlInvalid
        
        // When
        sut.fetchMetaDataURL(targetURLString: urlString) { webMetaData in
            promise.fulfill()
            XCTAssertNil(webMetaData.title)
            XCTAssertNil(webMetaData.faviconURLString)
            XCTAssertNil(webMetaData.webPreviewURLString)
        }
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    // MARK: - testFetchTitle
    /// 성공
    func testFetchTitle_whenSucceed() throws {
        // Given
        let promise = XCTestExpectation(description: "Response is Succeed")
        let urlString = "https://www.naver.com/"
        MockLPMetadataProvider.successMock[urlString] = "네이버"
        
        // When
        sut.fetchTitle(urlString: urlString) { title in
            promise.fulfill()
            guard let title = title else {
                XCTFail("title is nil")
                return
            }
            
            XCTAssertEqual(title, "네이버")
        }
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    /// title Fetch 실패
    /// 웹에 title 이 존재하지 않을 수 있기 때문에
    /// Error 가 아닌 nil 로 판단하도록 설계하였음
    func testFetchTitle_whenFailure() throws {
        // Given
        let promise = XCTestExpectation(description: "Response is Succeed")
        let urlString = "https://www.failure.com/"
        MockLPMetadataProvider.failureMock[urlString] = MockLPMetadataError.emptyTitle
        
        // When
        sut.fetchTitle(urlString: urlString) { title in
            promise.fulfill()
            XCTAssertNil(title)
        }
        
        // Then
        wait(for: [promise], timeout: 5)
    }
}
