//
//  ServiceManagerTests.swift
//  ImageGalleryTests
//
//  Created by Syed Zain ul Abideen on 18/03/2021.
//

import XCTest
import Combine

@testable import ImageGallery

class ServiceManagerTests: XCTestCase {

    var sut: ServiceManager<PexelAPIResponse>!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
      super.setUp()
      sut = ServiceManager()
      cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
      sut = nil
      cancellables = nil
      super.tearDown()
    }
    
    func testUnauthroizedAccess() {
        let promise = expectation(description: "Should return unauthorized acccess")
        if let request = RequestBuilder()
            .httpMethod(.get)
            .withType(.image)
            .queryParam([
            "query":"Cars",
            "per_page": "20",
            "page": "1"
        ]).build().request {
            
            sut.requestCombine(with: request)
                .sink { (completion) in
                    switch completion {
                        case .failure(let error): XCTAssertTrue(error.status == .unauthorized)
                        case .finished: XCTFail()
                    }
                    promise.fulfill()
                }
            receiveValue: { (response:PexelAPIResponse) in
                promise.fulfill()
                XCTFail()
            }
            .store(in: &cancellables)
            
            wait(for: [promise], timeout: 5)
        }
    }
    
    
    func testGetValidListOfImages() {
        let promise = expectation(description: "Should return valid List of images")
        if let request = RequestBuilder()
            .httpMethod(.get)
            .withType(.image)
            .authroizationValue(AppComponents.Strings.keyAPI)
            .queryParam([
            "query":"Cars",
            "per_page": "20",
            "page": "1"
        ]).build().request {
            
            sut.requestCombine(with: request)
                .sink { (completion) in
                    switch completion {
                        case .failure(_):  XCTFail()
                        case .finished: XCTAssertTrue(true)
                    }
                    
                    promise.fulfill()
                }
            receiveValue: { (response:PexelAPIResponse) in
                XCTAssertTrue(response.photos?.count ?? 0 > 0)
            }
            .store(in: &cancellables)
            
            wait(for: [promise], timeout: 5)
        }
    }
}
