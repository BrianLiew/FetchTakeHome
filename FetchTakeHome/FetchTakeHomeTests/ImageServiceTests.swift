//
//  ImageServiceTests.swift
//  FetchTakeHomeTests
//
//  Created by Brian Liew on 2/5/25.
//

import XCTest
@testable import FetchTakeHome

final class ImageServiceTests: XCTestCase {
    
    let sampleImage = UIImage(systemName: "info.circle")!
    let sampleImageID = "abc123"
    let sampleImageURL = "https://example.com/image.jpg"
    
    override func setUpWithError() throws {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockAPIProtocol.self]
        NetworkService.session = URLSession(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        self.removeSampleImageFromCache()
        
        MockAPIProtocol.data = nil
        MockAPIProtocol.response = nil
        MockAPIProtocol.error = nil
        
        super.tearDown()
    }
    
    private func removeSampleImageFromCache() {
        let url = ImageService.cacheDirectory.appendingPathComponent("\(sampleImageID).jpg")
        try? FileManager.default.removeItem(at: url)
    }
    
    func testFetchImage_FromCache() async throws {
        // Arrange
        ImageService.saveImageToCache(id: sampleImageID, image: sampleImage)
        
        // Act
        let image = try await ImageService.fetchImage(urlString: sampleImageURL, id: sampleImageID)
        
        // Assert
        XCTAssertNotNil(image)
    }
    
    func testFetchImage_FromNetwork() async throws {
        // Arrange
        guard let data = sampleImage.jpegData(compressionQuality: 1.0) else {
            XCTFail("Unexpected failure to convert sampleImage to Data")
            return
        }
        MockAPIProtocol.data = data
        MockAPIProtocol.response = HTTPURLResponse(url: URL(string: sampleImageURL)!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // Act
        let image = try await ImageService.fetchImage(urlString: sampleImageURL, id: sampleImageID)
        
        // Assert
        XCTAssertNotNil(image)
    }
    
    func testGetImageFromCache() {
        // Arrange
        self.removeSampleImageFromCache()
        ImageService.saveImageToCache(id: sampleImageID,
                                      image: sampleImage)
        
        // Act
        let image = ImageService.getImageFromCache(for: sampleImageID)
        
        // Assert
        XCTAssertNotNil(image)
    }
    
    func testSaveImageToCache() {
        // Arrange
        self.removeSampleImageFromCache()
        
        // Act
        ImageService.saveImageToCache(id: sampleImageID, image: sampleImage)
        
        // Assert
        let image = ImageService.getImageFromCache(for: sampleImageID)
        XCTAssertNotNil(image)
    }
    
}
