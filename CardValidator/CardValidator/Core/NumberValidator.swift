//
//  NumberValidator.swift
//  CardValidator
//
//  Created by Stanislav Ivanov on 19.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation



protocol NumberValidatorProtocol {
    func check(number: String) -> CardNumberError?
    func getBinFrom(number: String) -> String?
}


class NumberValidator: NumberValidatorProtocol {
    
    let minDigitsCount = 12
    let maxDigitsCount = 19
    
    let binDigitsCount = 6
    
// MARK: -
    func getBinFrom(number: String) -> String? {
        guard self.isOnlyDigitsIn(string: number) else {
            return nil
        }
        
        if number.count < self.binDigitsCount {
            return nil
        }

        return String( number.prefix(self.binDigitsCount) )
    }
    
    func check(number: String) -> CardNumberError? {
        
        guard self.isOnlyDigitsIn(string: number) else {
            return .wrongSymbols
        }
        
        guard number.count >= self.minDigitsCount else {
            return .shortNumber
        }
        
        guard number.count <= self.maxDigitsCount else {
            return .longNumber
        }
        
        guard self.checkLuhn(number: number) else {
            return .luhnFailed
        }
        
        return nil
    }
    
    func isOnlyDigitsIn(string: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
    
    func checkLuhn(number: String) -> Bool {
        
        let mod = number.count % 2
        
        var sum: Int = 0
        for (i, char) in number.enumerated() {
            guard var digitInt = Int(String(char)) else {
                return false
            }
            
            if i % 2 == mod {
                digitInt *= 2
                
                if digitInt > 9 {
                    digitInt -= 9
                }
            }
            
            sum += digitInt
        }
        
        return 0 == sum % 10
    }
}



