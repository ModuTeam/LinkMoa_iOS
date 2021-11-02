//
//  LPMetadataProviderProtocol.swift
//  LinkMoa
//
//  Created by won heo on 2021/08/30.
//

import LinkPresentation
import Foundation

public protocol LPMetadataProviderProtocol {
    func startFetchingMetadata(
        for URL: URL,
        completionHandler: @escaping (LPLinkMetadata?, Error?) -> Void
    )
    var timeout: TimeInterval { get set }
}

extension LPMetadataProvider: LPMetadataProviderProtocol {}
