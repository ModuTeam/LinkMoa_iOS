//
//  Report.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/16.
//

import Foundation

public struct ReportResponse: Codable {
    public let reportIndex: Int?
    public let isSuccess: Bool
    public let code: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case reportIndex = "reportIdx"
        case isSuccess, code, message
    }
}
