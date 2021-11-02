//
//  FileUtil.swift
//  LinkMoaTests
//
//  Created by won heo on 2021/08/30.
//

import Foundation

import Moya

enum TestUtilError: Error {
    case fileNotFound
}

class TestUtil {
    static func path(for fileName: String) throws -> String {
        if let path = Bundle.module.path(forResource: fileName, ofType: nil) {
            return path
        } else {
            throw TestUtilError.fileNotFound
        }
    }
}
