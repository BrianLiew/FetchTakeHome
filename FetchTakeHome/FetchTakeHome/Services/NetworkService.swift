//
//  NetworkService.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 1/31/25.
//

import Foundation
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    
    static var session: URLSession = URLSession(configuration: .default)
    
    static func fetch(urlString: String) async throws -> Response {
        do {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await NetworkService.session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.networkFailure
            }
            
            guard response.statusCode == 200 else {
                throw NetworkError.networkFailure
            }
            
            return try JSONDecoder().decode(Response.self, from: data)
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            throw error
        }
    }
    
    static func fetchImage(urlString: String) async throws -> UIImage {
        do {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await NetworkService.session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.networkFailure
            }
                        
            guard response.statusCode == 200 else {
                throw NetworkError.networkFailure
            }
            
            guard let image = UIImage(data: data) else {
                throw AppError.invalidImageData
            }
            
            return image
        } catch let error as NetworkError {
            throw error
        } catch let error as AppError {
            throw error
        }
    }
    
}
