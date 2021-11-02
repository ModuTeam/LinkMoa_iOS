//
//  LinkMoaLog.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/15.
//

import Foundation

@discardableResult
public func DEBUG_LOG(
    _ msg: Any,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) -> String {
    let filename = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    let message = "🥺[\(filename)] \(funcName) (\(line)): \(msg)"
    print(message)
    return message
}

@discardableResult
public func ERROR_LOG(
    _ msg: Any,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) -> String {
    let filename = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    let message = "😡[\(filename)] \(funcName) (\(line)): \(msg)"
    print(message)
    return message
}
