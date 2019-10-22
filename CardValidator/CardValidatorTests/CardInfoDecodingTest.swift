//
//  CardInfoDecodingTest.swift
//  CardValidatorTests
//
//  Created by Stanislav Ivanov on 20.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import XCTest

class CardInfoDecodingTest: XCTestCase {
    
    let decoder = JSONDecoder()


    func testExampleFromSite() {
        
        // https://binlist.net/
        // https://lookup.binlist.net/45717360
        
        
        let jsonString = """
{
  "number": {
    "length": 16,
    "luhn": true
  },
  "scheme": "visa",
  "type": "debit",
  "brand": "Visa/Dankort",
  "prepaid": false,
  "country": {
    "numeric": "208",
    "alpha2": "DK",
    "name": "Denmark",
    "emoji": "🇩🇰",
    "currency": "DKK",
    "latitude": 56,
    "longitude": 10
  },
  "bank": {
    "name": "Jyske Bank",
    "url": "www.jyskebank.dk",
    "phone": "+4589893300",
    "city": "Hjørring"
  }
}
"""
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        var cardInfo: CardNumberInfo?
        do {
            cardInfo = try self.decoder.decode(CardNumberInfo.self, from: data)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssertEqual(cardInfo?.scheme, "visa")
        XCTAssertEqual(cardInfo?.type,   "debit")
        XCTAssertEqual(cardInfo?.brand,  "Visa/Dankort")
        
        XCTAssertEqual(cardInfo?.country.code, "DK")
        
        XCTAssertEqual(cardInfo?.bank.name, "Jyske Bank")
    }


}
