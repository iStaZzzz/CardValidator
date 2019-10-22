//
//  NumberValidatorTests.swift
//  CardValidatorTests
//
//  Created by Stanislav Ivanov on 19.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import XCTest
@testable import CardValidator

class NumberValidatorTests: XCTestCase {
    
    let numberValidator = NumberValidator()


    func testBin() {
        // min symbols
        XCTAssertNil( self.numberValidator.getBinFrom(number: "12345") )
        
        // no digits
        XCTAssertNil( self.numberValidator.getBinFrom(number: "xxxxx") )
        
        let bin = self.numberValidator.getBinFrom(number: "12345678")
        XCTAssertEqual(bin, "123456")
    }
    
    func testShorNumbers() {
        var text: String = ""
        for _ in 0..<self.numberValidator.minDigitsCount - 1  {
            text += "0"
        }
        XCTAssertEqual(self.numberValidator.check(number: text), CardNumberError.shortNumber)
        
        text += "0"
        XCTAssertNil(self.numberValidator.check(number: text))
    }
    
    func testLongNumbers() {
        var text: String = ""
        for _ in 0..<self.numberValidator.maxDigitsCount {
            text += "0"
        }
        XCTAssertNil(self.numberValidator.check(number: text))
        
        text += "0"
        XCTAssertEqual(self.numberValidator.check(number: text), CardNumberError.longNumber)
    }
    
    func testNonDigitsNumbers() {
        var text: String = ""
        for _ in 0..<self.numberValidator.maxDigitsCount {
            text += "0"
        }
        XCTAssertNil(self.numberValidator.check(number: text))
        
        text = text.replacingOccurrences(of: "0", with: "x")
        XCTAssertEqual(self.numberValidator.check(number: text), CardNumberError.wrongSymbols)
    }
    
    func testLuhnNumbers() {
        // 16 digits
        XCTAssertNil(  self.numberValidator.check(number: "1234567812345670"))
        XCTAssertEqual(self.numberValidator.check(number: "1234567812345678"), CardNumberError.luhnFailed)
        
        // 13 digits
        XCTAssertNil(  self.numberValidator.check(number: "0049927398716"))
        XCTAssertEqual(self.numberValidator.check(number: "0049927398717"), CardNumberError.luhnFailed)
    }
    
    func testCardNumbers() {
        XCTAssertNotNil( self.numberValidator.check(number: "4929804463622138") )
        XCTAssertNotNil( self.numberValidator.check(number: "5212132012291762") )
        
        XCTAssertNil( self.numberValidator.check(number: "4929804463622139") )
        XCTAssertNil( self.numberValidator.check(number: "6762765696545485") )
        XCTAssertNil( self.numberValidator.check(number: "6210948000000029") )
    }
}
