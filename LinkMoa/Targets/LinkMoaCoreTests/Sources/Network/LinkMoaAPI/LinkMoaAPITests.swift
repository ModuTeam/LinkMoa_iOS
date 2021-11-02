//
//  LinkMoaAPITests.swift
//  LinkMoaAPITests
//
//  Created by won heo on 2021/08/24.
//

import XCTest

import Moya

@testable import LinkMoaCore

let linkMoaStubError = MoyaError.statusCode(Response(statusCode: 400, data: Data())) as NSError

let customEndpointClosure = { (target: LinkMoaAPI) -> Endpoint in
    return Endpoint(
        url: URL(target: target).absoluteString,
        sampleResponseClosure: { .networkError(linkMoaStubError) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
}

class LinkMoaAPITests: XCTestCase {
    func testProvider() throws {
        XCTAssertTrue((LinkMoaAPI.provider as Any) is MoyaProvider<LinkMoaAPI>)
    }
}
