//
//  Error.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 1/31/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkFailure
    case noDataReceived
    case imageNotFound
    
    var errorDescription: String {
        switch (self) {
        case .invalidURL:
            return "Network Error: Invalid URL"
        case .networkFailure:
            return "Network Error: Network request failed"
        case .noDataReceived:
            return "Network Error: No data received from server response"
        default:
            return "Network Error: Unknown error"
        }
    }
}

enum AppError: Error {
    case invalidImageData
    
    var errorDescription: String {
        switch (self) {
        case .invalidImageData:
            return "App Error: invalid image data"
        }
    }
}
