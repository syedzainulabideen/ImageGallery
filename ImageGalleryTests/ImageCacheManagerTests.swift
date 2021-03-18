//
//  ImageCacheManagerTests.swift
//  ImageGalleryTests
//
//  Created by Syed Zain ul Abideen on 18/03/2021.
//

import XCTest

@testable import ImageGallery

class ImageCacheManagerTests: XCTestCase {

    var sut: ImageCacheManager!
    let validImageURL = "https://images.pexels.com/photos/2645435/pexels-photo-2645435.jpeg"
    let randomInvalidImageURL = "https://cdn.pixabay.com/photo/2017/05/07/19/29/flower-2293332_1280.png"

    override func setUp() {
      super.setUp()
        sut = ImageCacheManager.shared
    }

    override func tearDown() {
      sut = nil
      super.tearDown()
    }
    
    func testImageCacheManagerSuccesssfullyCachedImage() {
        let promise = expectation(description: "Image data downloaded successfully")
        ImageLoader().loadURL(urlString:validImageURL) { data in
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        
        XCTAssertNotNil(sut.getCachedImage(for: validImageURL))
    }
    
    
    func testSomeRandomURLShouldNotbeInCache() {
        let someRandomImage = sut.getCachedImage(for: randomInvalidImageURL)
        XCTAssertNil(someRandomImage)
    }

}
