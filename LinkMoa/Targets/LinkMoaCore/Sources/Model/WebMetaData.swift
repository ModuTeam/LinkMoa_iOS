//
//  MetaData.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/10.
//

import Foundation

public struct WebMetaData {
    public let title: String?
    public let webPreviewURLString: String?
    public let faviconURLString: String?
    
    init(title: String?, webPreviewURLString: String?, faviconURLString: String?) {
        self.title = title
        self.webPreviewURLString = webPreviewURLString
        self.faviconURLString = faviconURLString
    }
    
    init() {
        self.init(title: nil, webPreviewURLString: nil, faviconURLString: nil)
    }
}
