//
//  CardNumberInfo.swift
//  CardValidator
//
//  Created by Stanislav Ivanov on 20.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation

private enum CodingKeys: String, CodingKey {
    
    // Common
    case name
    
    // Root
    case scheme
    case type
    case brand
    case country
    case bank
    
    // Country
    case code = "alpha2"
    case emoji
    
    // Bank
    case url
    case phone
    case city
}


struct CardNumberInfo: Decodable {
    let scheme: String
    let type:   String
    let brand:  String
    
    let country: CardNumberInfoCountry?
    
    let bank: CardNumberInfoBank?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.scheme = try container.decode(String.self, forKey: .scheme)
        self.type   = try container.decode(String.self, forKey: .type)
        self.brand  = try container.decode(String.self, forKey: .brand)
        
        self.country = try? container.decode(CardNumberInfoCountry.self, forKey: .country)
        
        self.bank = try? container.decode(CardNumberInfoBank.self, forKey: .bank)
    }
}

struct CardNumberInfoCountry: Decodable {
    let code:  String // https://www.iban.com/country-codes
    let name:  String
    let emoji: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code  = try container.decode(String.self, forKey: .code)
        self.name  = try container.decode(String.self, forKey: .name)
        self.emoji = try container.decode(String.self, forKey: .emoji)
    }
}

struct CardNumberInfoBank: Decodable {
    let name:  String
    let url:   String
    let phone: String
    let city:  String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name  = try container.decode(String.self, forKey: .name)
        self.url   = try container.decode(String.self, forKey: .url)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.city  = try container.decode(String.self, forKey: .city)
    }
}







