//
//  ImageLoaderTests.swift
//  ImageGalleryTests
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import XCTest

@testable import ImageGallery

class ImageLoaderTests: XCTestCase {

    var sut: ImageLoader!
    var validImageURL = "https://images.pexels.com/photos/2645435/pexels-photo-2645435.jpeg"
    var invalidImageURL = "https://cdn.pixabay.xyz"
    var notValidURL = "Just random string value"
    
    override func setUp() {
      super.setUp()
      sut = ImageLoader()
    }

    override func tearDown() {
      sut = nil
      super.tearDown()
    }
    
    func testImageLoaderInitialized() {
        XCTAssertNotNil(sut)
    }
    
    func testValidImageLoaded() {
        let promise = expectation(description: "Image data downloaded successfully")
        sut?.loadURL(urlString:validImageURL) { _ in
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        XCTAssert(sut.data.count > 0)
    }
    
    func testInvalidImageLoaded() {
        let promise = expectation(description: "No image data should be downloaded")
        sut?.loadURL(urlString:invalidImageURL) { _ in
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        XCTAssert(sut.data.count == 0)
    }
    
    func testDataConvertedToImage() {
        let promise = expectation(description: "Response data should converted to valid Image")
        sut?.loadURL(urlString:validImageURL) { data in
            promise.fulfill()
            let image = UIImage(data: data!)
            XCTAssertNotNil(image)
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testNotaValidURL() {
        let promise = expectation(description: "Returned immediately, as input is not a valid URL")
        sut?.loadURL(urlString:notValidURL) { data in
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        XCTAssert(sut.data.count == 0)
    }
}
