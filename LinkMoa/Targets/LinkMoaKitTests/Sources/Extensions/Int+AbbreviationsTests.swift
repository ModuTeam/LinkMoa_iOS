//
//  Int+AbbreviationsTests.swift
//  LinkMoaKitTests
//
//  Created by won heo on 2021/09/17.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import XCTest

@testable import LinkMoaKit

class Int_AbbreviationsTests: XCTestCase {
    func testThousand_whenNumberIsThousand() throws {
        XCTAssertEqual(Int.thousand, Int(pow(10.0, 3)))
    }
    
    func testTenThousand_whenNumberIsTenThousand() throws {
        XCTAssertEqual(Int.tenThousand, Int(pow(10.0, 4)))
    }
    
    func testHundredMillion_whenNumberIshundredMillion() throws {
        XCTAssertEqual(Int.hundredMillion, Int(pow(10.0, 8)))
    }
    
    func testToAbbreviationString_whenNumberIshundredMillion() throws {
        let number = Int.hundredMillion
        XCTAssertEqual(number.toAbbreviationString, "1억")
    }
    
    func testToAbbreviationString_whenNumberIshundredMillion_withOnedecimalPoint() throws {
        let number = Int.hundredMillion + Int.hundredMillion / 10
        XCTAssertEqual(number.toAbbreviationString, "1.1억")
    }
    
    func testToAbbreviationString_whenNumberIstenThousand() throws {
        let number = Int.tenThousand
        XCTAssertEqual(number.toAbbreviationString, "1만")
    }
    
    func testToAbbreviationString_whenNumberIstenThousand_withOnedecimalPoint() throws {
        let number = Int.tenThousand + Int.thousand
        XCTAssertEqual(number.toAbbreviationString, "1.1만")
    }

    func testToAbbreviationString_whenNumberIsthousand() throws {
        let number = Int.thousand
        XCTAssertEqual(number.toAbbreviationString, "1천")
    }
    
    func testToAbbreviationString_whenNumberIsthousand_withOnedecimalPoint() throws {
        let number = Int.thousand + 100
        XCTAssertEqual(number.toAbbreviationString, "1.1천")
    }
    
    func testToAbbreviationString_whenNumberIsUnderThousand() throws {
        let number = Int(100)
        XCTAssertEqual(number.toAbbreviationString, "100")
    }
}
