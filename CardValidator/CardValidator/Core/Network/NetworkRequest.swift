//
//  NetworkRequest.swift
//  CardValidator
//
//  Created by Stanislav Ivanov on 19.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation


protocol NetworkRequestProtocol {
    func build() -> URLRequest?
}


// MARK: - 

fileprivate enum NetworkRequestMethod: String {
    case get = "GET"
}

class NetworkRequest: NetworkRequestProtocol {
    
    func build() -> URLRequest? {
        guard let url = URL(string: self.urlString()) else { return nil }
        
        var request = URLRequest(url: url, cachePolicy: self.cachePolicy(), timeoutInterval: self.timeoutInterval())
        request.httpMethod = self.method().rawValue
        return request
    }
    
    // MARK: -
    
    fileprivate init() {}
    
    fileprivate func urlString() -> String { return "" }
    
    fileprivate func method() -> NetworkRequestMethod { return .get }
    
    fileprivate func timeoutInterval() -> TimeInterval { return 15 }
    
    fileprivate func cachePolicy() -> NSURLRequest.CachePolicy { return .reloadIgnoringCacheData }
}

class CardNumberInfoNetworkReqeust: NetworkRequest {

    let cardBin: String
    
    required init(cardBin: String) {
        self.cardBin = cardBin
    }
    
    override func urlString() -> String {
        return "https://lookup.binlist.net/\(self.cardBin)"
    }
}
