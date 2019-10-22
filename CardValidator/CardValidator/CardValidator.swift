//
//  CardValidator.swift
//  CardValidator
//
//  Created by Stanislav Ivanov on 19.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import Foundation


/// Info about card from API
/**
* [bin](x-source-tag://CardInfo.bin)
* [countryCode](x-source-tag://CardInfo.countryCode)
* [bankName](x-source-tag://CardInfo.bankName)
* [brand](x-source-tag://CardInfo.brand)
*/
public struct CardInfo: Hashable {
    
    /// identification number. 6 digits
    /// - Tag: CardInfo.bin
    public let bin: String
    
    /// ALPHA-2 country code [See more](https://www.iban.com/country-codes)
    /// - Tag: CardInfo.countryCode
    public let countryCode: String?
    
    /// Name of bank
    /// - Tag: CardInfo.bankName
    public let bankName: String?
    
    /// Brand: visa, mastercard etc.
    /// - Tag: CardInfo.brand
    public let brand: String
}


/// Internal error
/**
* [wrongSymbols](x-source-tag://CardNumberError.wrongSymbols)
* [shortNumber](x-source-tag://CardNumberError.shortNumber)
* [longNumber](x-source-tag://CardNumberError.longNumber)
* [luhnFailed](x-source-tag://CardNumberError.luhnFailed)
* [wrongBin](x-source-tag://CardNumberError.wrongBin)
*/
public enum CardNumberError: Error {
        
    /// Card number has wrong symbols (not a number)
    /// - Tag: CardNumberError.wrongSymbols
    case wrongSymbols
    
    /// Card number wrong length (short)
    /// - Tag: CardNumberError.shortNumber
    case shortNumber
        
    /// Card number wrong length (long)
    /// - Tag: CardNumberError.longNumber
    case longNumber
        
    /// Card has wrong digits. [See more](https://en.wikipedia.org/wiki/Luhn_algorithm)
    /// - Tag: CardNumberError.luhnFailed
    case luhnFailed
        
    /// Card has wrong  [bin](x-source-tag://CardInfo.bin)
    /// - Tag: CardNumberError.wrongBin
    case wrongBin
}


/// Closure with result of API call (get info about card)
/**
Result:
* info: Information about card. May be nil if something went wrong
* error: Error with information if something went wrong
*/
public typealias CardInfoCompletion = (_ info: CardInfo?, _ error: Error?) -> Void




/// Protocol for card number handling
/**
* [checkNumber](x-source-tag://CardValidatorProtocol.checkNumber)
* [getInfo](x-source-tag://CardValidatorProtocol.getInfo)
*/
/// - Tag: CardValidatorProtocol
public protocol CardValidatorProtocol {
    
    /// Local check of card number
    /// - Parameter number: String with card number digits
    /// - Returns: Error if card number is invalid, nil otherwise
    /// - Tag: CardValidatorProtocol.checkNumber
    func check(number: String) -> CardNumberError?

    /// Get info about card from API
    /// - Parameter number: String with card number digits
    /// - Parameter completion: Closure for async result
    /// - Tag: CardValidatorProtocol.getInfo
    func getInfo(number: String, completion:  @escaping CardInfoCompletion)
}


/// Info about card from API. Implements [CardValidatorProtocol](x-source-tag://CardValidatorProtocol)
public class CardValidator {
    public static let shared: CardValidatorProtocol = CardValidatorCore()
}
