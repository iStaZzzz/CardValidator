//
//  CardValidatorCore.swift
//  CardValidator
//
//  Created by Stanislav Ivanov on 22.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation


class CardValidatorCore {
    
    private let numberValidator: NumberValidatorProtocol = NumberValidator()
    
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    
    private var cardInfoCache: [ String : CardInfo] = [:]
}

/// Implementation of [CardValidatorProtocol](x-source-tag://CardValidatorProtocol)
extension CardValidatorCore: CardValidatorProtocol {
    
    /// Implementation of [checkNumber](x-source-tag://CardValidatorProtocol.checkNumber)
    public func check(number: String) -> CardNumberError? {
        return self.numberValidator.check(number: number)
    }
    
    /// Implementation of [getInfo](x-source-tag://CardValidatorProtocol.getInfo)
    public func getInfo(number: String, completion: @escaping CardInfoCompletion) {
        
        guard let bin = self.numberValidator.getBinFrom(number: number) else {
            completion(nil, CardNumberError.wrongBin)
            return
        }
        
        if let cardInfo = self.cardInfoCache[bin] {
            completion(cardInfo, nil)
            return
        }
        
        let request = CardNumberInfoNetworkReqeust.init(cardBin: bin)
        let requestCompletion: NetworkManagerCompletion<CardNumberInfo> = { (response: CardNumberInfo?, error: Error?) in
            
            var cardInfo: CardInfo? = nil
            if let cardNumberInfo = response {
                cardInfo = CardInfo(bin: bin,
                                    countryCode: cardNumberInfo.country?.code,
                                    bankName: cardNumberInfo.bank?.name,
                                    brand: cardNumberInfo.brand)
                self.cardInfoCache[bin] = cardInfo
            }
            
            completion(cardInfo, error)
        }
        self.networkManager.execute(request: request, completion: requestCompletion)
    }
}
