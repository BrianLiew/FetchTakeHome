//
//  MockAPIProtocol.swift
//  FetchTakeHomeTests
//
//  Created by Brian Liew on 2/5/25.
//

import Foundation

class MockAPIProtocol: URLProtocol {
    
    static var data: Data?
    static var response: URLResponse?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockAPIProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
            return
        }
        else {
            if let response = MockAPIProtocol.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockAPIProtocol.data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
