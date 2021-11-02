//
//  MockLPMetadataProvider.swift
//  LinkMoaTests
//
//  Created by won heo on 2021/08/30.
//

import LinkPresentation
import Foundation

@testable import LinkMoaCore

enum MockLPMetadataError: Error {
    case notSupported
    case emptyTitle
}

final class MockLPMetadataProvider: LPMetadataProviderProtocol {
    static var successMock: [RequestURL: String] = [:]
    static var failureMock: [RequestURL: Error] = [:]
    var timeout: TimeInterval = 0.0
    
    func startFetchingMetadata(
        for URL: URL,
        completionHandler: @escaping (LPLinkMetadata?, Error?) -> Void
    ) {
        if let title = MockLPMetadataProvider.successMock[URL.absoluteString] {
            let linkMetadata = LPLinkMetadata()
            linkMetadata.title = title
            completionHandler(linkMetadata, nil)
        } else if let error = MockLPMetadataProvider.failureMock[URL.absoluteString] {
            completionHandler(nil, error)
        } else {
            completionHandler(nil, MockLPMetadataError.notSupported)
        }
    }
}
