//
//  NetworkServiceTests.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 2/5/25.
//

import XCTest
@testable import FetchTakeHome

final class NetworkServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockAPIProtocol.self]
        NetworkService.session = URLSession(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        MockAPIProtocol.data = nil
        MockAPIProtocol.response = nil
        MockAPIProtocol.error = nil
        
        super.tearDown()
    }
    
    func testFetch_SuccessfulResponse() async throws {
        // Arrange
        let json = """
                { "recipes": [{
                                "cuisine": "Malaysian",
                                "name": "Apam Balik",
                                "photo_url_large": "",
                                "photo_url_small": "",
                                "uuid": "1",
                                "source_url": "",
                                "youtube_url": "" 
                            }]
                }
                """.data(using: .utf8)!
        MockAPIProtocol.data = json
        MockAPIProtocol.response = HTTPURLResponse(url: URL(string: APIURLs.allRecipesURL)!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // Act
        let result = try await NetworkService.fetch(urlString: APIURLs.allRecipesURL)
        
        // Assert
        XCTAssertEqual(result.recipes.count, 1)
        XCTAssertEqual(result.recipes.first?.name, "Apam Balik")
    }
    
    func testFetch_InvalidURL() async {
        // Arrange
        let urlString = ""
        
        // Act
        do {
            _ = try await NetworkService.fetch(urlString: urlString)
            XCTFail("Expected NetworkError.invalidURL error, but no error was thrown.")
        } catch let error as NetworkError {
            // Assert
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetch_HttpStatusCodeNot200() async {
        // Arrange
        MockAPIProtocol.response = HTTPURLResponse(url: URL(string: APIURLs.allRecipesURL)!,
                                                   statusCode: 500,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // Act
        do {
            _ = try await NetworkService.fetch(urlString: APIURLs.allRecipesURL)
            XCTFail("Expected networkFailure error, but no error was thrown.")
        } catch let error as NetworkError {
            // Assert
            XCTAssertEqual(error, .networkFailure)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetch_DecodingError() async {
        // Arrange
        let invalidJsonData = "{ invalid json }".data(using: .utf8)!
        MockAPIProtocol.data = invalidJsonData
        MockAPIProtocol.response = HTTPURLResponse(url: URL(string: APIURLs.allRecipesURL)!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // Act
        do {
            _ = try await NetworkService.fetch(urlString: APIURLs.allRecipesURL)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch is DecodingError {
            // Assert
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchImage_SuccessfulResponse() async {
        // Arrange
        let image = UIImage(systemName: "info.circle")
        let data = image?.jpegData(compressionQuality: 1.0)
        MockAPIProtocol.data = data
        MockAPIProtocol.response = HTTPURLResponse(url: URL(string: APIURLs.allRecipesURL)!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // Act
        do {
            let result = try await NetworkService.fetchImage(urlString: "https://example.com/image.png")
            // Assert
            XCTAssertNotNil(result)
        } catch {
            
        }
    }
    
    func testFetchImage_InvalidURL() async {
        // Arrange
        let urlString = ""
        
        // Act
        do {
            _ = try await NetworkService.fetchImage(urlString: urlString)
            XCTFail("Expected NetworkError.invalidURL error, but no error was thrown.")
        } catch let error as NetworkError {
            // Assert
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchImage_HttpStatusCodeNot200() async {
        // Arrange
        MockAPIProtocol.response = HTTPURLResponse(url: URL(string: "https://example.com/image.png")!,
                                                   statusCode: 500,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // Act
        do {
            _ = try await NetworkService.fetchImage(urlString: "https://example.com/image.png")
            XCTFail("Expected networkFailure error, but no error was thrown.")
        } catch let error as NetworkError {
            // Assert
            XCTAssertEqual(error, .networkFailure)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchImage_InvalidImageData() async {
        // Arrange
        let data = Data([])
        MockAPIProtocol.data = data
        MockAPIProtocol.response = HTTPURLResponse(url: URL(string: "https://example.com/image.png")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // Act
        do {
            _ = try await NetworkService.fetchImage(urlString:  "https://example.com/image.png")
            XCTFail("Expected invalidImageData error, but no error was thrown.")
        } catch let error as AppError {
            // Assert
            XCTAssertEqual(error, AppError.invalidImageData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
}


